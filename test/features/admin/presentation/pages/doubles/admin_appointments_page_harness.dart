import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:clinic_appointment_system/core/localization/app_formatters.dart';
import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart'
    hide AppointmentStatus;
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/features/admin/presentation/cubit/admin_appointments_cubit.dart';
import 'package:clinic_appointment_system/features/admin/presentation/cubit/admin_dashboard_cubit.dart';
import 'package:clinic_appointment_system/features/admin/presentation/extensions/admin_appointment_route_query.dart';
import 'package:clinic_appointment_system/features/admin/presentation/pages/admin_appointments_page.dart';
import 'package:clinic_appointment_system/features/admin/presentation/pages/admin_home_page.dart';
import 'package:clinic_appointment_system/features/admin/presentation/widgets/admin_shell.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/change_appointment_status_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_admin_appointments_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_pending_appointments_use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_clinics_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_of_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_catalog_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_services_of_branches_use_case.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/appointment_approve_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/appointment_reject_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/appointment_staff_cancel_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/usecases/watch_staff_use_case.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/admin.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
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
import '../../../../institution/presentation/doubles/clinic_catalog_repositories.dart';
import '../../support/admin_dashboard_fixture.dart';

/// Real admin Cubits over controllable appointment and clinic catalog streams.
final class AdminAppointmentsPageHarness {
  static const Size desktop = Size(1440, 960);
  static const AdminDashboardFixture fixtures = AdminDashboardFixture();

  final ClinicCatalogRepositories catalogRepositories =
      ClinicCatalogRepositories();
  final StaffAppointmentRepository appointments = StaffAppointmentRepository();
  final FixedClock clock = FixedClock(DateTime(2026, 11, 14, 8));
  final MockAuthRepository authRepository = MockAuthRepository();
  late final AuthCubit auth;
  ClinicCatalogCubit? catalogCubit;
  AdminAppointmentsCubit? adminAppointmentsCubit;
  AdminDashboardCubit? adminDashboardCubit;

  /// Registers test dependencies and signs in an administrator.
  Future<void> initialize() async {
    await AppDependency.injector.reset();
    await AppFormatters.ensureInitialized();
    when(() => authRepository.authStateChanges()).thenAnswer(
      (_) => Stream.value(
        const DataResult.success(
          data: AuthSession(
            userId: 'admin-1',
            email: 'admin@example.com',
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
      TestUserRepository()
        ..getResult = const DataResult<User>.success(
          data: Admin(
            id: 'admin-1',
            fullName: 'Nur Karaca',
            email: 'admin@example.com',
          ),
        ),
    );
    await auth.stream.firstWhere((state) => state is AuthSignedIn);
    _registerDependencies();
  }

  /// Pumps the real page with one watched catalog Cubit.
  Future<void> pumpPage(WidgetTester tester, {Size size = desktop}) async {
    _setSize(tester, size);
    final screenSize = BreakpointsConstants.resolve(size.width, size.height);
    final catalogWatch = AppDependency.injector.get<ClinicCatalogCubit>()
      ..watch();
    catalogCubit = catalogWatch;
    await loadTestTranslations(
      tester,
      theme: LightTheme(screenSize).themeData,
      settle: false,
      child: _withSessionAndCatalog(
        catalogWatch,
        const AdminAppointmentsPage(),
      ),
    );
    await tester.pump();
  }

  /// Pumps the overview with real Cubits backed by controllable streams.
  Future<void> pumpHomePage(WidgetTester tester, {Size size = desktop}) async {
    _setSize(tester, size);
    final screenSize = BreakpointsConstants.resolve(size.width, size.height);
    final catalogWatch = AppDependency.injector.get<ClinicCatalogCubit>()
      ..watch();
    catalogCubit = catalogWatch;
    await loadTestTranslations(
      tester,
      theme: LightTheme(screenSize).themeData,
      settle: false,
      child: _withSessionAndCatalog(catalogWatch, const AdminHomePage()),
    );
    await tester.pump();
  }

  /// Pumps the overview in the admin shell with routable appointment targets.
  Future<GoRouter> pumpRoutedHomePage(
    WidgetTester tester, {
    Size size = desktop,
  }) async {
    _setSize(tester, size);
    final screenSize = BreakpointsConstants.resolve(size.width, size.height);
    final catalogWatch = AppDependency.injector.get<ClinicCatalogCubit>()
      ..watch();
    catalogCubit = catalogWatch;
    final router = GoRouter(
      initialLocation: AppRoutes.adminHome,
      routes: [
        ShellRoute(
          builder: (context, state, child) => AdminShell(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.adminHome,
              builder: (context, state) => const AdminHomePage(),
            ),
            GoRoute(
              path: AppRoutes.adminAppointments,
              builder: (context, state) => AdminAppointmentsPage(
                initialStatuses: state.uri.initialAdminAppointmentStatuses,
              ),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    await loadTestTranslations(
      tester,
      theme: LightTheme(screenSize).themeData,
      settle: false,
      child: _withSessionAndCatalog(
        catalogWatch,
        MaterialApp.router(
          routerConfig: router,
          theme: LightTheme(screenSize).themeData,
        ),
      ),
    );
    await tester.pump();
    return router;
  }

  /// Emits every directory collection and the supplied appointment rows.
  Future<void> loadData(WidgetTester tester, List<Appointment> rows) async {
    await loadCatalog(tester);
    await emitRows(tester, rows);
  }

  /// Emits every clinic directory collection.
  Future<void> loadCatalog(WidgetTester tester) async {
    final catalog = fixtures.catalog;
    await tester.runAsync(() async {
      catalogRepositories.clinics.emit(clinicCatalogAllKey, catalog.clinics);
      catalogRepositories.staff.emit(clinicCatalogAllKey, catalog.staff);
      await Future<void>.delayed(Duration.zero);
      catalogRepositories.branches.emit('clinic', catalog.branches);
      await Future<void>.delayed(Duration.zero);
      final branchIds = catalog.branches.map((branch) => branch.id).toList()
        ..sort();
      final branchKey = branchIds.join(',');
      catalogRepositories.departments.emit(branchKey, catalog.departments);
      catalogRepositories.services.emit(branchKey, catalog.services);
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pump();
  }

  /// Emits [rows] to the active administrator appointment observation.
  Future<void> emitRows(WidgetTester tester, List<Appointment> rows) async {
    await tester.runAsync(() async {
      appointments.emit(rows);
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pumpAndSettle();
  }

  /// Emits an appointment observation failure after the catalog has loaded.
  Future<void> failAppointments(WidgetTester tester) async {
    await tester.runAsync(() async {
      appointments.events.add(
        const DataResult<List<Appointment>>.error(
          errorCode: AppointmentErrorCode.unavailable,
        ),
      );
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pumpAndSettle();
  }

  /// Creates predictable rows in the date range used by the fixed clock.
  List<Appointment> appointmentRows({
    required int count,
    int pendingCount = 1,
  }) {
    return [
      for (int index = 0; index < count; index++)
        fixtures.appointment(
          id: 'appointment-$index',
          status: index < pendingCount
              ? AppointmentStatus.pending
              : AppointmentStatus.approved,
          startMinutes: 600 + index * 20,
          branchId: index.isEven ? 'branch-a' : 'branch-b',
          departmentId: index.isEven ? 'department-a' : 'department-b',
          staffId: index.isEven ? 'staff-z' : 'staff-b',
        ),
    ];
  }

  /// Closes every scoped Cubit and test stream after unmounting the page.
  Future<void> dispose(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await catalogCubit?.close();
    await auth.close();
    await catalogRepositories.close();
    await appointments.events.close();
    await AppDependency.injector.reset();
  }

  void _registerDependencies() {
    final injector = AppDependency.injector;
    injector.registerSingleton<Clock>(clock);
    injector.registerFactory<ClinicCatalogCubit>(
      () => ClinicCatalogCubit(
        WatchClinicsUseCase(catalogRepositories),
        WatchBranchesUseCase(catalogRepositories),
        WatchDepartmentsOfBranchesUseCase(catalogRepositories),
        WatchServicesOfBranchesUseCase(catalogRepositories),
        WatchStaffUseCase(catalogRepositories),
      ),
    );
    injector.registerFactory<AdminAppointmentsCubit>(() {
      final cubit = AdminAppointmentsCubit(
        WatchAdminAppointmentsUseCase(appointments),
        clock,
      );
      adminAppointmentsCubit = cubit;
      return cubit;
    });
    injector.registerFactory<AdminDashboardCubit>(() {
      final cubit = AdminDashboardCubit(
        WatchAdminAppointmentsUseCase(appointments),
        WatchPendingAppointmentsUseCase(appointments),
        clock,
      );
      adminDashboardCubit = cubit;
      return cubit;
    });
    injector.registerFactory<AppointmentApproveCubit>(
      () => AppointmentApproveCubit(
        ChangeAppointmentStatusUseCase(appointments, clock),
      ),
    );
    injector.registerFactory<AppointmentRejectCubit>(
      () => AppointmentRejectCubit(
        ChangeAppointmentStatusUseCase(appointments, clock),
      ),
    );
    injector.registerFactory<AppointmentStaffCancelCubit>(
      () => AppointmentStaffCancelCubit(
        ChangeAppointmentStatusUseCase(appointments, clock),
      ),
    );
  }

  MultiBlocProvider _withSessionAndCatalog(
    ClinicCatalogCubit catalog,
    Widget child,
  ) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: auth),
        BlocProvider<ClinicCatalogCubit>.value(value: catalog),
      ],
      child: child,
    );
  }

  void _setSize(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }
}
