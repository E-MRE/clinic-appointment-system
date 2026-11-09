import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:clinic_appointment_system/core/localization/app_formatters.dart';
import 'package:clinic_appointment_system/core/localization/localization_wrapper.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/book_appointment_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/change_appointment_status_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_patient_appointments_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_staff_booked_slots_use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_appointment_system/features/availability/domain/services/slot_generator.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/watch_staff_availability_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_clinics_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_of_branches_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_services_of_branches_use_case.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/book_appointment_cubit.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/booking_selection_cubit.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/patient_appointment_cancel_cubit.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/patient_appointments_cubit.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/patient_appointments_tab_cubit.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/patient_catalog_cubit.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/staff_week_schedule_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/usecases/watch_staff_use_case.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../core/time/support/fixed_clock.dart';
import '../../../../support/auth_cubit_factory.dart';
import '../../../../support/auth_repository_doubles.dart';
import '../../../../support/localization_test_app.dart';
import '../../../../support/user_repository_double.dart';
import 'patient_appointment_repository.dart';
import 'patient_availability_repository.dart';
import 'patient_catalog_repositories.dart';
import 'patient_fixtures.dart';

/// Real patient cubits over controllable catalog and appointment streams.
final class PatientPageHarness {
  static const Size mobile = Size(390, 844);
  static const Size tablet = Size(834, 1194);
  static const Size desktop = Size(1440, 960);
  static const PatientFixtures fixtures = PatientFixtures();

  final PatientCatalogRepositories catalog = PatientCatalogRepositories();
  final PatientAppointmentRepository appointments =
      PatientAppointmentRepository();
  final PatientAvailabilityRepository availability =
      PatientAvailabilityRepository();
  final MockAuthRepository authRepository = MockAuthRepository();
  final FixedClock clock = FixedClock(fixtures.now);
  late final AuthCubit auth;

  /// Signs the fixture patient in and registers the patient cubits.
  Future<void> initialize() async {
    await AppFormatters.ensureInitialized();
    final profile = fixtures.patient;
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
    AppDependency.injector.registerSingleton<Clock>(clock);
    registerCubits();
  }

  /// Registers only the patient cubits; other harnesses own Clock and auth.
  void registerCubits() {
    final injector = AppDependency.injector;
    injector.registerFactory<PatientCatalogCubit>(
      () => PatientCatalogCubit(
        WatchClinicsUseCase(catalog),
        WatchBranchesUseCase(catalog),
        WatchDepartmentsOfBranchesUseCase(catalog),
        WatchServicesOfBranchesUseCase(catalog),
        WatchStaffUseCase(catalog),
      ),
    );
    injector.registerFactory<PatientAppointmentsCubit>(
      () => PatientAppointmentsCubit(
        WatchPatientAppointmentsUseCase(appointments),
      ),
    );
    injector.registerFactory<PatientAppointmentsTabCubit>(
      PatientAppointmentsTabCubit.new,
    );
    injector.registerFactory<PatientAppointmentCancelCubit>(
      () => PatientAppointmentCancelCubit(
        ChangeAppointmentStatusUseCase(appointments, clock),
      ),
    );
    injector.registerFactory<BookingSelectionCubit>(
      () => BookingSelectionCubit(clock),
    );
    injector.registerFactory<StaffWeekScheduleCubit>(
      () => StaffWeekScheduleCubit(
        WatchStaffAvailabilityUseCase(availability),
        WatchStaffBookedSlotsUseCase(appointments),
        clock,
        const SlotGenerator(),
      ),
    );
    injector.registerFactory<BookAppointmentCubit>(
      () => BookAppointmentCubit(
        BookAppointmentUseCase(appointments, clock),
        clock,
      ),
    );
  }

  void _setSize(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  /// Pumps [router] inside the localized, themed application frame.
  Future<void> pumpRouter(
    WidgetTester tester,
    GoRouter router, {
    Size size = desktop,
    bool dark = false,
  }) async {
    _setSize(tester, size);
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
                theme: dark
                    ? DarkTheme(screenSize).themeData
                    : LightTheme(screenSize).themeData,
                routerConfig: router,
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Emits the fixture catalog and appointments.
  Future<void> load(WidgetTester tester) async {
    await tester.runAsync(() async {
      catalog.clinics.emit(catalogAllKey, [fixtures.clinic]);
      catalog.staff.emit(catalogAllKey, fixtures.staff);
      await Future<void>.delayed(Duration.zero);
      catalog.branches.emit('clinic', [fixtures.branch]);
      await Future<void>.delayed(Duration.zero);
      catalog.departments.emit('branch', fixtures.departments);
      catalog.services.emit('branch', fixtures.services);
      appointments.emit(fixtures.appointments);
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pumpAndSettle();
  }

  /// Delivers pending stream events and settles the frame.
  Future<void> flush(WidgetTester tester) async {
    await tester.runAsync(() async {
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pumpAndSettle();
  }

  /// Closes the streams owned by this harness.
  Future<void> disposeRepositories() async {
    await catalog.close();
    await appointments.events.close();
    await appointments.bookedSlots.close();
    await availability.close();
  }

  Future<void> dispose(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await auth.close();
    await disposeRepositories();
    await AppDependency.injector.reset();
  }
}
