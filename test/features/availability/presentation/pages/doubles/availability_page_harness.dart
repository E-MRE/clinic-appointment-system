import 'dart:async';

import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:clinic_appointment_system/core/localization/app_formatters.dart';
import 'package:clinic_appointment_system/core/localization/localization_wrapper.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/availability_policy.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/add_availability_window_use_case.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/remove_availability_window_use_case.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/watch_staff_availability_use_case.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/watch_staff_service_durations_use_case.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/availability_branch_cubit.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/availability_window_draft_cubit.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/availability_window_save_cubit.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/staff_availability_cubit.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/staff_service_durations_cubit.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_branch_use_case.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../core/time/support/fixed_clock.dart';
import '../../../../../support/auth_cubit_factory.dart';
import '../../../../../support/auth_repository_doubles.dart';
import '../../../../../support/localization_test_app.dart';
import '../../../../../support/user_repository_double.dart';
import '../../../../medical_services/domain/doubles/fake_medical_service_repository.dart';
import '../../../../staff_management/domain/doubles/staff_fixtures.dart';
import '../../../domain/support/availability_fixture.dart';
import '../../doubles/mock_branch_repository.dart';
import 'availability_page_repository.dart';

/// Real page cubits with repository-controlled observations and mutations.
final class AvailabilityPageHarness {
  static const Size mobile = Size(390, 844);
  static const Size tablet = Size(834, 1194);
  static const Size desktop = Size(1200, 960);
  static const AvailabilityFixture fixture = AvailabilityFixture();
  static const StaffFixtures staffFixtures = StaffFixtures();
  final Staff staff = staffFixtures.doctor(
    id: 'staff',
    specialty: 'Kardiyoloji',
  );
  final AvailabilityPageRepository repository = AvailabilityPageRepository(
    fixture.empty,
  );
  final MockBranchRepository branches = MockBranchRepository();
  final MockAuthRepository authRepository = MockAuthRepository();
  final StreamController<DataResult<Branch>> branchEvents =
      StreamController.broadcast();
  final FixedClock clock = FixedClock(DateTime(2026, 11, 2));
  late final AuthCubit auth;
  late StaffAvailabilityCubit availability;
  late AvailabilityBranchCubit branchCubit;
  late AvailabilityWindowSaveCubit save;
  late AvailabilityWindowDraftCubit draft;
  bool branchLoaded = false;
  int branchWatchCalls = 0;

  Branch get branch => Branch(
    id: 'branch',
    clinicId: 'clinic',
    name: 'Merkez Şube',
    address: 'Adres',
    workingHours: fixture.hours,
  );
  StaffAvailability get loaded => fixture.empty
      .withWeekly([fixture.weekly(540, 600), fixture.weekly(780, 840)])
      .withOneOff([fixture.oneOff(990, 1050)]);

  Future<void> initialize({User? user}) async {
    await AppFormatters.ensureInitialized();
    final profile = user ?? staff;
    when(() => authRepository.authStateChanges()).thenAnswer(
      (_) => Stream.value(
        DataResult.success(
          data: AuthSession(
            userId: profile.id,
            email: profile.email,
            isEmailVerified: true,
          ),
        ),
      ),
    );
    when(
      () => authRepository.signOut(),
    ).thenAnswer((_) async => const Result.success());
    auth = createAuthCubit(
      authRepository,
      TestUserRepository()..getResult = DataResult.success(data: profile),
    );
    await auth.stream.firstWhere((state) => state is AuthSignedIn);
    registerCubits();
  }

  /// Registers only availability dependencies for existing application router tests.
  void registerCubits() {
    when(() => branches.watchBranch(any())).thenAnswer((_) {
      branchWatchCalls++;
      return Stream.multi((sink) {
        if (branchLoaded) sink.add(DataResult.success(data: branch));
        final subscription = branchEvents.stream.listen(
          sink.add,
          onError: sink.addError,
        );
        sink.onCancel = subscription.cancel;
      });
    });
    final services = FakeMedicalServiceRepository()
      ..servicesStream = Stream.value(const DataResult.success(data: []));
    final injector = AppDependency.injector;
    injector.registerSingleton<Clock>(clock);
    injector.registerFactory<StaffAvailabilityCubit>(() {
      availability = StaffAvailabilityCubit(
        WatchStaffAvailabilityUseCase(repository),
      );
      return availability;
    });
    injector.registerFactory<AvailabilityBranchCubit>(() {
      branchCubit = AvailabilityBranchCubit(WatchBranchUseCase(branches));
      return branchCubit;
    });
    injector.registerFactory<StaffServiceDurationsCubit>(
      () => StaffServiceDurationsCubit(
        WatchStaffServiceDurationsUseCase(services),
      ),
    );
    injector.registerFactory<AvailabilityWindowDraftCubit>(() {
      draft = AvailabilityWindowDraftCubit(clock);
      return draft;
    });
    injector.registerFactory<AvailabilityWindowSaveCubit>(() {
      save = AvailabilityWindowSaveCubit(
        AddAvailabilityWindowUseCase(
          repository,
          branches,
          clock,
          const AvailabilityPolicy.standard(),
        ),
        RemoveAvailabilityWindowUseCase(repository, clock),
      );
      return save;
    });
  }

  void setSize(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    Size size = mobile,
    bool dark = false,
    TextScaler? textScaler,
  }) async {
    setSize(tester, size);
    final screenSize = BreakpointsConstants.resolve(size.width, size.height);
    await loadTestTranslations(
      tester,
      settle: false,
      theme: dark
          ? DarkTheme(screenSize).themeData
          : LightTheme(screenSize).themeData,
      textScaler: textScaler,
      child: BlocProvider<AuthCubit>.value(value: auth, child: child),
    );
  }

  Future<void> pumpRouter(
    WidgetTester tester,
    GoRouter router, {
    Size size = mobile,
  }) async {
    setSize(tester, size);
    final screenSize = BreakpointsConstants.resolve(size.width, size.height);
    await pumpLocalizedWidget(
      tester,
      LocalizationWrapper(
        child: Builder(
          builder: (context) {
            return BlocProvider<AuthCubit>.value(
              value: auth,
              child: MaterialApp.router(
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                theme: LightTheme(screenSize).themeData,
                routerConfig: router,
              ),
            );
          },
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
  }

  Future<void> load(WidgetTester tester, {StaffAvailability? value}) async {
    repository.current = value ?? loaded;
    await tester.runAsync(() async {
      branchLoaded = true;
      branchEvents.add(DataResult.success(data: branch));
      repository.events.add(DataResult.success(data: repository.current));
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pumpAndSettle();
  }

  Future<void> flush(WidgetTester tester) async {
    await tester.runAsync(() async {
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pumpAndSettle();
  }

  /// Closes repository streams when another harness owns authentication and DI.
  Future<void> disposeRepositories() async {
    await repository.events.close();
    await branchEvents.close();
  }

  Future<void> dispose(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await auth.close();
    await disposeRepositories();
    await AppDependency.injector.reset();
  }
}
