import 'dart:async';

import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/localization/localization_wrapper.dart';
import 'package:clinic_appointment_system/core/router/app_router.dart';
import 'package:clinic_appointment_system/core/states/theme_cubit.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/presentation/auth_route_guard.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/create_branch_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/create_clinic_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/create_department_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/update_branch_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/update_clinic_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/update_department_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_clinics_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_save_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_save_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_save_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/working_hours_editor_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/create_medical_service_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/update_medical_service_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_medical_services_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_editor_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_filter_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_form_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_list_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_save_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/pages/medical_service_form_page.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/pages/medical_services_page.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/admin.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../support/auth_cubit_factory.dart';
import '../../../../support/auth_repository_doubles.dart';
import '../../../../support/localization_test_app.dart';
import '../../../../support/user_repository_double.dart';
import '../../../institution/domain/doubles/fake_branch_repository.dart';
import '../../../institution/domain/doubles/fake_clinic_repository.dart';
import '../../../institution/domain/doubles/fake_department_repository.dart';
import '../../domain/doubles/fake_medical_service_repository.dart';

void main() {
  tearDown(() async => AppDependency.injector.reset());

  const clinic = Clinic(id: 'c1', name: 'Central Clinic');
  final branch = Branch(
    id: 'b1',
    clinicId: 'c1',
    name: 'Main Branch',
    address: 'Central Street',
    workingHours: WorkingHours.closed(),
  );

  testWidgets(
    'selection persists from institution to services route and watches branch',
    (tester) async {
      final clinics = FakeClinicRepository()
        ..clinicsStream = Stream.value(
          const DataResult.success(data: [clinic]),
        );
      final branches = FakeBranchRepository()
        ..branchesStream = Stream.value(DataResult.success(data: [branch]));
      final departments = FakeDepartmentRepository()
        ..departmentsStream = Stream.value(
          const DataResult.success(data: <Department>[]),
        );
      final servicesRepo = FakeMedicalServiceRepository()
        ..servicesStream = Stream.value(
          const DataResult.success(data: <MedicalService>[]),
        );

      final router = _setupRouter(
        AppRoutes.institution,
        clinics: clinics,
        branches: branches,
        departments: departments,
        services: servicesRepo,
      );
      addTearDown(router.dispose);

      await _pumpRouter(tester, router);

      // Verify initial institution page loaded and selected the branch
      expect(find.text('Main Branch'), findsOneWidget);

      // Navigate to /admin/services
      router.go(AppRoutes.services);
      await tester.pumpAndSettle();

      expect(find.byType(MedicalServicesPage), findsOneWidget);
      expect(
        router.routeInformationProvider.value.uri.path,
        AppRoutes.services,
      );
      expect(servicesRepo.watchedBranchId, 'b1');
    },
  );

  testWidgets('admin reaches services and service new routes', (tester) async {
    const adminUser = Admin(
      id: 'admin-id',
      fullName: 'Admin User',
      email: 'admin@clinic.com',
    );

    final authRepository = MockAuthRepository();
    when(() => authRepository.authStateChanges()).thenAnswer(
      (_) => Stream.value(
        const DataResult<AuthSession>.success(
          data: AuthSession(
            userId: 'admin-id',
            email: 'admin@clinic.com',
            isEmailVerified: true,
          ),
        ),
      ),
    );
    final users = TestUserRepository()
      ..getResult = const DataResult.success(data: adminUser);
    final authCubit = createAuthCubit(authRepository, users);
    await authCubit.stream.firstWhere((state) => state is AuthSignedIn);
    final guard = AuthRouteGuard(authCubit);

    final clinics = FakeClinicRepository()
      ..clinicsStream = Stream.value(const DataResult.success(data: [clinic]));
    final branches = FakeBranchRepository()
      ..branchesStream = Stream.value(DataResult.success(data: [branch]));
    final departments = FakeDepartmentRepository()
      ..departmentsStream = const Stream.empty();
    final services = FakeMedicalServiceRepository()
      ..servicesStream = const Stream.empty();

    final router = _setupRouter(
      AppRoutes.services,
      clinics: clinics,
      branches: branches,
      departments: departments,
      services: services,
      guard: guard,
    );
    addTearDown(() async {
      router.dispose();
      guard.dispose();
      await authCubit.close();
    });

    await _pumpRouter(tester, router);
    expect(find.byType(MedicalServicesPage), findsOneWidget);
    expect(router.routeInformationProvider.value.uri.path, AppRoutes.services);

    router.go(AppRoutes.serviceNew);
    await tester.pumpAndSettle();

    expect(find.byType(MedicalServiceFormPage), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      AppRoutes.serviceNew,
    );
  });

  testWidgets('patient navigating to services is redirected to patient home', (
    tester,
  ) async {
    const patientUser = Patient(
      id: 'patient-id',
      fullName: 'Patient User',
      email: 'patient@clinic.com',
    );

    final authRepository = MockAuthRepository();
    when(() => authRepository.authStateChanges()).thenAnswer(
      (_) => Stream.value(
        const DataResult<AuthSession>.success(
          data: AuthSession(
            userId: 'patient-id',
            email: 'patient@clinic.com',
            isEmailVerified: true,
          ),
        ),
      ),
    );
    final users = TestUserRepository()
      ..getResult = const DataResult.success(data: patientUser);
    final authCubit = createAuthCubit(authRepository, users);
    await authCubit.stream.firstWhere((state) => state is AuthSignedIn);
    final guard = AuthRouteGuard(authCubit);

    final clinics = FakeClinicRepository();
    final branches = FakeBranchRepository();
    final departments = FakeDepartmentRepository();
    final services = FakeMedicalServiceRepository();

    final router = _setupRouter(
      AppRoutes.services,
      clinics: clinics,
      branches: branches,
      departments: departments,
      services: services,
      guard: guard,
    );
    addTearDown(() async {
      router.dispose();
      guard.dispose();
      await authCubit.close();
    });

    await _pumpRouter(tester, router);
    expect(
      router.routeInformationProvider.value.uri.path,
      AppRoutes.patientHome,
    );
  });
}

GoRouter _setupRouter(
  String path, {
  required FakeClinicRepository clinics,
  required FakeBranchRepository branches,
  required FakeDepartmentRepository departments,
  required FakeMedicalServiceRepository services,
  AuthRouteGuard? guard,
}) {
  AppDependency.injector.registerFactory<ClinicListCubit>(
    () => ClinicListCubit(WatchClinicsUseCase(clinics)),
  );
  AppDependency.injector.registerFactory<BranchListCubit>(
    () => BranchListCubit(WatchBranchesUseCase(branches)),
  );
  AppDependency.injector.registerFactory<DepartmentListCubit>(
    () => DepartmentListCubit(WatchDepartmentsUseCase(departments)),
  );
  AppDependency.injector.registerFactory<ClinicSaveCubit>(
    () => ClinicSaveCubit(
      CreateClinicUseCase(clinics),
      UpdateClinicUseCase(clinics),
    ),
  );
  AppDependency.injector.registerFactory<BranchSaveCubit>(
    () => BranchSaveCubit(
      CreateBranchUseCase(branches),
      UpdateBranchUseCase(branches),
    ),
  );
  AppDependency.injector.registerFactory<DepartmentSaveCubit>(
    () => DepartmentSaveCubit(
      CreateDepartmentUseCase(departments),
      UpdateDepartmentUseCase(departments),
    ),
  );
  AppDependency.injector.registerFactory<WorkingHoursEditorCubit>(
    WorkingHoursEditorCubit.new,
  );
  AppDependency.injector.registerFactory<MedicalServiceListCubit>(
    () => MedicalServiceListCubit(WatchMedicalServicesUseCase(services)),
  );
  AppDependency.injector.registerFactory<MedicalServiceSaveCubit>(
    () => MedicalServiceSaveCubit(
      CreateMedicalServiceUseCase(services),
      UpdateMedicalServiceUseCase(services),
    ),
  );
  AppDependency.injector.registerFactory<MedicalServiceFilterCubit>(
    MedicalServiceFilterCubit.new,
  );
  AppDependency.injector.registerFactory<MedicalServiceFormCubit>(
    MedicalServiceFormCubit.new,
  );
  AppDependency.injector.registerFactory<MedicalServiceEditorCubit>(
    MedicalServiceEditorCubit.new,
  );
  return createAppRouter(initialLocation: path, authGuard: guard);
}

Future<void> _pumpRouter(WidgetTester tester, GoRouter router) async {
  await pumpLocalizedWidget(
    tester,
    LocalizationWrapper(
      child: Builder(
        builder: (context) {
          return BlocProvider(
            create: (_) => ThemeCubit(),
            child: MaterialApp.router(
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              theme: LightTheme(ScreenSize.mobile).themeData,
              routerConfig: router,
            ),
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
}
