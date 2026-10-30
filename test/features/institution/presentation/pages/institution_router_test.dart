import 'dart:async';

import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
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
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/working_hours_editor_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/branch_detail_page.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_page.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/admin.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
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
import '../../domain/doubles/fake_branch_repository.dart';
import '../../domain/doubles/fake_clinic_repository.dart';
import '../../domain/doubles/fake_department_repository.dart';

void main() {
  tearDown(() async => AppDependency.injector.reset());
  const firstClinic = Clinic(id: 'first', name: 'First Clinic');
  const secondClinic = Clinic(id: 'second', name: 'Second Clinic');
  final secondBranch = Branch(
    id: 'second-branch',
    clinicId: 'second',
    name: 'Second Branch',
    address: 'Second Street',
    workingHours: WorkingHours.closed(),
  );

  for (final (user, home) in [
    (
      const Admin(id: 'id', fullName: 'Admin', email: 'admin@test.com'),
      AppRoutes.adminHome,
    ),
    (
      const Patient(id: 'id', fullName: 'Patient', email: 'patient@test.com'),
      AppRoutes.patientHome,
    ),
    (
      const Doctor(
        id: 'id',
        fullName: 'Doctor',
        email: 'doctor@test.com',
        branchId: 'b',
        departmentId: 'd',
      ),
      AppRoutes.staffHome,
    ),
  ]) {
    for (final path in [
      AppRoutes.institution,
      AppRoutes.branchDetail('second', 'second-branch'),
    ]) {
      testWidgets('${user.role} guard routes $path', (tester) async {
        final authRepository = MockAuthRepository();
        when(() => authRepository.authStateChanges()).thenAnswer(
          (_) => Stream.value(
            const DataResult<AuthSession>.success(
              data: AuthSession(
                userId: 'id',
                email: 'a@test.com',
                isEmailVerified: true,
              ),
            ),
          ),
        );
        final users = TestUserRepository()
          ..getResult = DataResult.success(data: user);
        final authCubit = createAuthCubit(authRepository, users);
        await authCubit.stream.firstWhere((state) => state is AuthSignedIn);
        final guard = AuthRouteGuard(authCubit);
        final clinics = FakeClinicRepository()
          ..clinicsStream = Stream.value(
            const DataResult.success(data: [firstClinic, secondClinic]),
          );
        final branches = FakeBranchRepository()
          ..branchesStream = Stream.value(
            DataResult.success(data: [secondBranch]),
          );
        final departments = FakeDepartmentRepository()
          ..departmentsStream = Stream.value(
            const DataResult.success(data: <Department>[]),
          );
        final router = _router(
          path,
          clinics,
          branches,
          departments,
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
          home == AppRoutes.adminHome ? path : home,
        );
      });
    }
  }

  testWidgets('deep link resolves a branch in the non-first clinic', (
    tester,
  ) async {
    final clinics = FakeClinicRepository()
      ..clinicsStream = Stream.value(
        const DataResult.success(data: [firstClinic, secondClinic]),
      );
    final branches = FakeBranchRepository()
      ..branchesStream = Stream.value(DataResult.success(data: [secondBranch]));
    final departments = FakeDepartmentRepository()
      ..departmentsStream = Stream.value(
        const DataResult.success(data: <Department>[]),
      );
    final router = _router(
      AppRoutes.branchDetail('second', 'second-branch'),
      clinics,
      branches,
      departments,
    );
    addTearDown(router.dispose);
    await _pumpRouter(tester, router);
    expect(find.byType(BranchDetailPage), findsOneWidget);
    expect(find.text('Second Branch'), findsOneWidget);
    expect(branches.watchedClinicId, 'second');
  });

  testWidgets('moving between branch details watches the new branch', (
    tester,
  ) async {
    final otherBranch = Branch(
      id: 'other-branch',
      clinicId: 'second',
      name: 'Other Branch',
      address: 'Other Street',
      workingHours: WorkingHours.closed(),
    );
    final clinics = FakeClinicRepository()
      ..clinicsStream = Stream.value(
        const DataResult.success(data: [firstClinic, secondClinic]),
      );
    final branches = FakeBranchRepository()
      ..branchesStream = Stream.value(
        DataResult.success(data: [secondBranch, otherBranch]),
      );
    // Each branch selection subscribes again and receives an empty list.
    late final StreamController<DataResult<List<Department>>> departmentStream;
    departmentStream = StreamController.broadcast(
      onListen: () {
        departmentStream.add(const DataResult.success(data: <Department>[]));
      },
    );
    addTearDown(departmentStream.close);
    final departments = FakeDepartmentRepository()
      ..departmentsStream = departmentStream.stream;
    final router = _router(
      AppRoutes.branchDetail('second', 'second-branch'),
      clinics,
      branches,
      departments,
    );
    addTearDown(router.dispose);
    await _pumpRouter(tester, router);
    expect(departments.watchedBranchId, 'second-branch');

    router.go(AppRoutes.branchDetail('second', 'other-branch'));
    await tester.pumpAndSettle();

    expect(find.text('Other Branch'), findsOneWidget);
    expect(departments.watchedBranchId, 'other-branch');
  });

  testWidgets('unknown clinic and branch show not found after lists load', (
    tester,
  ) async {
    final clinics = FakeClinicRepository()
      ..clinicsStream = Stream.value(
        const DataResult.success(data: [firstClinic, secondClinic]),
      );
    final branchStream = StreamController<DataResult<List<Branch>>>.broadcast();
    addTearDown(branchStream.close);
    final branches = FakeBranchRepository()
      ..branchesStream = branchStream.stream;
    final departments = FakeDepartmentRepository();
    final router = _router(
      AppRoutes.branchDetail('missing', 'branch'),
      clinics,
      branches,
      departments,
    );
    addTearDown(router.dispose);
    await _pumpRouter(tester, router);
    expect(find.text('Kayıt bulunamadı'), findsOneWidget);
    router.go(AppRoutes.branchDetail('second', 'missing'));
    await tester.pump();
    expect(find.text('Kayıt bulunamadı'), findsNothing);
    await tester.runAsync(() async {
      branchStream.add(DataResult.success(data: [secondBranch]));
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pumpAndSettle();
    expect(find.text('Kayıt bulunamadı'), findsOneWidget);
  });

  testWidgets('switching clinic to one without branches clears departments', (
    tester,
  ) async {
    final clinics = FakeClinicRepository()
      ..clinicsStream = Stream.value(
        const DataResult.success(data: [firstClinic, secondClinic]),
      );
    final branch = Branch(
      id: 'first-branch',
      clinicId: 'first',
      name: 'First Branch',
      address: 'First Street',
      workingHours: WorkingHours.closed(),
    );
    final branches = FakeBranchRepository()
      ..branchesStream = Stream.value(DataResult.success(data: [branch]));
    final departments = FakeDepartmentRepository()
      ..departmentsStream = Stream.value(
        const DataResult.success(
          data: [Department(id: 'd1', branchId: 'first-branch', name: 'Old')],
        ),
      );
    late DepartmentListCubit departmentCubit;
    final router = _router(
      AppRoutes.branchDetail('first', 'first-branch'),
      clinics,
      branches,
      departments,
      onDepartments: (cubit) => departmentCubit = cubit,
    );
    addTearDown(router.dispose);
    await _pumpRouter(tester, router);
    expect(departmentCubit.state, isA<InstitutionListLoaded<Department>>());
    branches.branchesStream = Stream.value(
      const DataResult.success(data: <Branch>[]),
    );
    router.go(AppRoutes.branchNew('second'));
    await tester.pumpAndSettle();
    expect(branches.watchedClinicId, 'second');
    expect(departmentCubit.state, isA<InstitutionListLoading<Department>>());
    expect(departments.watchedBranchId, 'first-branch');
  });

  testWidgets('admin institution route reaches the page', (tester) async {
    final clinics = FakeClinicRepository();
    final branches = FakeBranchRepository();
    final departments = FakeDepartmentRepository();
    final router = _router(
      AppRoutes.institution,
      clinics,
      branches,
      departments,
    );
    addTearDown(router.dispose);
    await pumpLocalizedWidget(
      tester,
      LocalizationWrapper(
        child: Builder(
          builder: (context) {
            return MaterialApp.router(
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              theme: LightTheme(ScreenSize.mobile).themeData,
              routerConfig: router,
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(InstitutionPage), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      AppRoutes.institution,
    );
  });
}

GoRouter _router(
  String path,
  FakeClinicRepository clinics,
  FakeBranchRepository branches,
  FakeDepartmentRepository departments, {
  void Function(DepartmentListCubit)? onDepartments,
  AuthRouteGuard? guard,
}) {
  AppDependency.injector.registerFactory<ClinicListCubit>(
    () => ClinicListCubit(WatchClinicsUseCase(clinics)),
  );
  AppDependency.injector.registerFactory<BranchListCubit>(
    () => BranchListCubit(WatchBranchesUseCase(branches)),
  );
  AppDependency.injector.registerFactory<DepartmentListCubit>(() {
    final cubit = DepartmentListCubit(WatchDepartmentsUseCase(departments));
    onDepartments?.call(cubit);
    return cubit;
  });
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
