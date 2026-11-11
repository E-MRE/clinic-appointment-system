import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:clinic_appointment_system/core/localization/app_formatters.dart';
import 'package:clinic_appointment_system/core/localization/localization_wrapper.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/change_appointment_status_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_staff_appointments_use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/watch_staff_availability_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_branch_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_medical_services_use_case.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/appointment_approve_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_appointments_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_workspace_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/pages/staff_requests_page.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
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
import '../../../../appointments/presentation/doubles/staff_appointment_repository.dart';
import '../../../../availability/domain/doubles/fake_staff_availability_repository.dart';
import '../../../../availability/presentation/doubles/mock_branch_repository.dart';
import '../../../../institution/domain/doubles/fake_department_repository.dart';
import '../../../../medical_services/domain/doubles/fake_medical_service_repository.dart';

/// Authenticated staff page with controllable appointment events and changes.
final class StaffRequestsPageHarness {
  /// Viewport sizes required by the requests page acceptance criteria.
  static const Size mobile = Size(390, 844);
  static const Size tablet = Size(834, 1194);
  static const Size desktop = Size(1440, 960);

  /// Mutable staff appointment boundary used by this harness.
  final StaffAppointmentRepository repository = StaffAppointmentRepository();

  /// Fixed time keeping approval and request ranges deterministic.
  final Clock clock = FixedClock(DateTime(2026, 10, 20, 9));

  final MockAuthRepository _authRepository = MockAuthRepository();
  late final AuthCubit auth;
  late final Doctor staff;

  /// Initializes a signed-in doctor and the page's screen-scoped cubits.
  Future<void> initialize() async {
    await AppFormatters.ensureInitialized();
    await AppDependency.injector.reset();
    staff = const Doctor(
      id: 'staff',
      fullName: 'Dr. Ada Kaya',
      email: 'ada@example.com',
      branchId: 'branch',
      departmentId: 'department',
      serviceIds: ['service'],
      specialty: 'Cardiology',
    );
    when(() => _authRepository.authStateChanges()).thenAnswer(
      (_) => Stream.value(
        DataResult.success(
          data: AuthSession(
            userId: staff.id,
            email: staff.email,
            isEmailVerified: true,
          ),
        ),
      ),
    );
    when(
      () => _authRepository.signOut(),
    ).thenAnswer((_) async => const Result.success());
    auth = createAuthCubit(
      _authRepository,
      TestUserRepository()..getResult = DataResult.success(data: staff),
    );
    await auth.stream.firstWhere((state) => state is AuthSignedIn);
    AppDependency.injector.registerSingleton<Clock>(clock);
    AppDependency.injector.registerFactory<StaffAppointmentsCubit>(
      () => StaffAppointmentsCubit(
        WatchStaffAppointmentsUseCase(repository),
        clock,
      ),
    );
    AppDependency.injector.registerFactory<AppointmentApproveCubit>(
      () => AppointmentApproveCubit(
        ChangeAppointmentStatusUseCase(repository, clock),
      ),
    );
    final branchRepo = MockBranchRepository();
    when(() => branchRepo.watchBranch(any())).thenAnswer(
      (_) => Stream.value(
        DataResult.success(
          data: Branch(
            id: 'branch',
            clinicId: 'clinic',
            name: 'Merkez Şube',
            address: 'Adres',
            workingHours: WorkingHours.closed(),
          ),
        ),
      ),
    );
    final departmentRepo = FakeDepartmentRepository()
      ..departmentsStream = Stream.value(
        const DataResult.success(
          data: [
            Department(
              id: 'department',
              branchId: 'branch',
              name: 'Cardiology',
            ),
          ],
        ),
      ).asBroadcastStream();
    final servicesRepo = FakeMedicalServiceRepository()
      ..servicesStream = Stream.value(
        const DataResult<List<MedicalService>>.success(data: []),
      ).asBroadcastStream();
    final availabilityRepo =
        FakeStaffAvailabilityRepository(
            StaffAvailability(staffId: staff.id, branchId: 'branch'),
          )
          ..stream = Stream.value(
            DataResult.success(
              data: StaffAvailability(staffId: staff.id, branchId: 'branch'),
            ),
          ).asBroadcastStream();
    AppDependency.injector.registerFactory<StaffWorkspaceCubit>(
      () => StaffWorkspaceCubit(
        WatchStaffAvailabilityUseCase(availabilityRepo),
        WatchBranchUseCase(branchRepo),
        WatchDepartmentsUseCase(departmentRepo),
        WatchMedicalServicesUseCase(servicesRepo),
      ),
    );
  }

  /// Pumps [StaffRequestsPage] at [size] with the real localized app theme.
  Future<void> pump(WidgetTester tester, {required Size size}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final screenSize = BreakpointsConstants.resolve(size.width, size.height);
    final appointmentsCubit =
        AppDependency.injector.get<StaffAppointmentsCubit>()..watch(staff.id);
    addTearDown(appointmentsCubit.close);
    final workspaceCubit = AppDependency.injector.get<StaffWorkspaceCubit>()
      ..watch(staff);
    addTearDown(workspaceCubit.close);
    await loadTestTranslations(
      tester,
      theme: LightTheme(screenSize).themeData,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>.value(value: auth),
          BlocProvider<StaffAppointmentsCubit>.value(value: appointmentsCubit),
          BlocProvider<StaffWorkspaceCubit>.value(value: workspaceCubit),
        ],
        child: const StaffRequestsPage(),
      ),
    );
  }

  /// Pumps the application router so shell routing can be verified.
  Future<void> pumpRouter(
    WidgetTester tester,
    GoRouter router, {
    required Size size,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final screenSize = BreakpointsConstants.resolve(size.width, size.height);
    await pumpLocalizedWidget(
      tester,
      LocalizationWrapper(
        child: Builder(
          builder: (context) => BlocProvider<AuthCubit>.value(
            value: auth,
            child: MaterialApp.router(
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              theme: LightTheme(screenSize).themeData,
              routerConfig: router,
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
  }

  /// Emits a new repository list and lets the widget tree process it.
  Future<void> emitAndPump(
    WidgetTester tester,
    List<Appointment> appointments,
  ) async {
    await tester.runAsync(() async {
      repository.emit(appointments);
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pumpAndSettle();
  }

  /// Closes screen state, auth and repository resources.
  Future<void> dispose(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await auth.close();
    await repository.events.close();
    await AppDependency.injector.reset();
  }
}
