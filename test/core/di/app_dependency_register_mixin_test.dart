import 'package:clinic_appointment_system/core/di/app_dependency_register_mixin.dart';
import 'package:clinic_appointment_system/core/di/get_it/get_it_dependency_injection_manager.dart';
import 'package:clinic_appointment_system/core/di/injector/dependency_injector.dart';
import 'package:clinic_appointment_system/core/errors/unexpected_exception.dart';
import 'package:clinic_appointment_system/core/states/theme_cubit.dart';
import 'package:clinic_appointment_system/features/auth/data/mappers/firebase_auth_exception_mapper.dart';
import 'package:clinic_appointment_system/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:clinic_appointment_system/features/auth/domain/mappers/auth_exception_mapper.dart';
import 'package:clinic_appointment_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/register_patient_use_case.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_state.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:clinic_appointment_system/features/institution/data/repositories/firestore_branch_repository.dart';
import 'package:clinic_appointment_system/features/institution/data/repositories/firestore_clinic_repository.dart';
import 'package:clinic_appointment_system/features/institution/data/repositories/firestore_department_repository.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/branch_repository.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/clinic_repository.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/department_repository.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/create_branch_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/create_clinic_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/create_department_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/update_branch_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/update_clinic_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/update_department_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_clinics_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_use_case.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_save_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_save_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_save_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/working_hours_editor_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/medical_service_model_factory.dart';
import 'package:clinic_appointment_system/features/medical_services/data/repositories/firestore_medical_service_repository.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/repositories/medical_service_repository.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/create_medical_service_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/update_medical_service_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_medical_services_use_case.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../support/firebase_auth_doubles.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late DependencyInjector container;
  late MockFirebaseAuth auth;

  setUp(() async {
    final dependency = GetItDependencyInjectionManager();
    container = dependency.injector;
    await container.reset();
    dependency.register(
      customInjections: _DependencyRegistrar().registerDependencies,
    );
    await container.unregister<FirebaseFirestore>();
    container.registerSingleton<FirebaseFirestore>(FakeFirebaseFirestore());
    await container.unregister<FirebaseAuth>();
    auth = MockFirebaseAuth();
    when(() => auth.authStateChanges()).thenAnswer((_) => const Stream.empty());
    container.registerSingleton<FirebaseAuth>(auth);
  });
  tearDown(() => container.reset());

  test(
    'factory registrations create separate instances and can be removed',
    () async {
      container.registerFactory<_TestService>(
        _TestService.new,
        instanceName: 'factory',
      );
      expect(
        container.get<_TestService>(instanceName: 'factory'),
        isNot(same(container.get<_TestService>(instanceName: 'factory'))),
      );
      await container.unregister<_TestService>(instanceName: 'factory');
      expect(
        container.isRegistered<_TestService>(instanceName: 'factory'),
        isFalse,
      );
    },
  );

  test(
    'lazy reset awaits cleanup and recreates the service on next access',
    () async {
      int disposals = 0;
      container.registerLazySingleton<_TestService>(
        _TestService.new,
        instanceName: 'lazy',
        dispose: (_) async {
          disposals++;
        },
      );
      final original = container.get<_TestService>(instanceName: 'lazy');
      await container.resetLazySingleton<_TestService>(instanceName: 'lazy');
      expect(disposals, 1);
      expect(
        container.get<_TestService>(instanceName: 'lazy'),
        isNot(same(original)),
      );
      await container.unregister<_TestService>(instanceName: 'lazy');
      expect(disposals, 2);
    },
  );

  test('every registered type resolves and app services are shared', () {
    final cubit = container.get<ThemeCubit>();
    final router = container.get<GoRouter>();
    expect(container.get<ThemeCubit>(), same(cubit));
    expect(container.get<GoRouter>(), same(router));
    expect(cubit.state, ThemeMode.light);
    final repository = container.get<AuthRepository>();
    expect(repository, isA<FirebaseAuthRepository>());
    expect(container.get<AuthRepository>(), same(repository));
    expect(container.get<FirebaseAuth>(), same(auth));
    final mapper = container.get<AuthExceptionMapper>();
    expect(mapper, isA<FirebaseAuthExceptionMapper>());
    expect(container.get<AuthExceptionMapper>(), same(mapper));
    final authCubit = container.get<AuthCubit>();
    expect(container.get<AuthCubit>(), same(authCubit));
    final registerPatient = container.get<RegisterPatientUseCase>();
    expect(container.get<RegisterPatientUseCase>(), same(registerPatient));
  });

  test('institution repositories and use cases resolve through DI', () {
    final clinics = container.get<ClinicRepository>();
    final branches = container.get<BranchRepository>();
    final departments = container.get<DepartmentRepository>();
    expect(clinics, isA<FirestoreClinicRepository>());
    expect(branches, isA<FirestoreBranchRepository>());
    expect(departments, isA<FirestoreDepartmentRepository>());
    expect(container.get<ClinicRepository>(), same(clinics));
    expect(container.get<BranchRepository>(), same(branches));
    expect(container.get<DepartmentRepository>(), same(departments));

    expect(container.get<WatchClinicsUseCase>(), isA<WatchClinicsUseCase>());
    expect(container.get<CreateClinicUseCase>(), isA<CreateClinicUseCase>());
    expect(container.get<UpdateClinicUseCase>(), isA<UpdateClinicUseCase>());
    expect(container.get<WatchBranchesUseCase>(), isA<WatchBranchesUseCase>());
    expect(container.get<CreateBranchUseCase>(), isA<CreateBranchUseCase>());
    expect(container.get<UpdateBranchUseCase>(), isA<UpdateBranchUseCase>());
    expect(
      container.get<WatchDepartmentsUseCase>(),
      isA<WatchDepartmentsUseCase>(),
    );
    expect(
      container.get<CreateDepartmentUseCase>(),
      isA<CreateDepartmentUseCase>(),
    );
    expect(
      container.get<UpdateDepartmentUseCase>(),
      isA<UpdateDepartmentUseCase>(),
    );
  });

  test('medical services repository and use cases resolve through DI', () {
    final factory = container.get<MedicalServiceModelFactory>();
    final repository = container.get<MedicalServiceRepository>();
    expect(factory, isA<MedicalServiceModelFactory>());
    expect(repository, isA<FirestoreMedicalServiceRepository>());
    expect(container.get<MedicalServiceModelFactory>(), same(factory));
    expect(container.get<MedicalServiceRepository>(), same(repository));

    expect(
      container.get<WatchMedicalServicesUseCase>(),
      isA<WatchMedicalServicesUseCase>(),
    );
    expect(
      container.get<CreateMedicalServiceUseCase>(),
      isA<CreateMedicalServiceUseCase>(),
    );
    expect(
      container.get<UpdateMedicalServiceUseCase>(),
      isA<UpdateMedicalServiceUseCase>(),
    );
  });

  test(
    'institution presentation cubits resolve as screen-owned factories',
    () async {
      final first = <Object>[
        container.get<ClinicListCubit>(),
        container.get<BranchListCubit>(),
        container.get<DepartmentListCubit>(),
        container.get<ClinicSaveCubit>(),
        container.get<BranchSaveCubit>(),
        container.get<DepartmentSaveCubit>(),
        container.get<WorkingHoursEditorCubit>(),
      ];
      final second = <Object>[
        container.get<ClinicListCubit>(),
        container.get<BranchListCubit>(),
        container.get<DepartmentListCubit>(),
        container.get<ClinicSaveCubit>(),
        container.get<BranchSaveCubit>(),
        container.get<DepartmentSaveCubit>(),
        container.get<WorkingHoursEditorCubit>(),
      ];

      for (int index = 0; index < first.length; index++) {
        expect(first[index], isNot(same(second[index])));
      }
      await Future.wait([
        (first[0] as ClinicListCubit).close(),
        (first[1] as BranchListCubit).close(),
        (first[2] as DepartmentListCubit).close(),
        (first[3] as ClinicSaveCubit).close(),
        (first[4] as BranchSaveCubit).close(),
        (first[5] as DepartmentSaveCubit).close(),
        (first[6] as WorkingHoursEditorCubit).close(),
        (second[0] as ClinicListCubit).close(),
        (second[1] as BranchListCubit).close(),
        (second[2] as DepartmentListCubit).close(),
        (second[3] as ClinicSaveCubit).close(),
        (second[4] as BranchSaveCubit).close(),
        (second[5] as DepartmentSaveCubit).close(),
        (second[6] as WorkingHoursEditorCubit).close(),
      ]);
    },
  );

  test('auth repository uses the injected Firebase instance', () async {
    when(() => auth.authStateChanges()).thenAnswer((_) => Stream.value(null));
    final result = await container
        .get<AuthRepository>()
        .authStateChanges()
        .first;
    expect(result.isSuccess, isTrue);
    expect(result.data, isNull);
    verify(() => auth.authStateChanges()).called(1);
  });

  test(
    'request cubits resolve as independent screen-owned instances',
    () async {
      final pairs = <(AuthRequestCubit, AuthRequestCubit)>[
        (container.get<SignInCubit>(), container.get<SignInCubit>()),
        (container.get<SignUpCubit>(), container.get<SignUpCubit>()),
        (
          container.get<PasswordResetCubit>(),
          container.get<PasswordResetCubit>(),
        ),
      ];
      for (final (first, second) in pairs) {
        expect(first, isNot(same(second)));
        expect(first.state, isA<AuthRequestInitial>());
        expect(second.state, isA<AuthRequestInitial>());
        await first.close();
        await second.close();
      }
    },
  );

  test('repository uses the mapper registered through its interface', () async {
    final mapper = _MockAuthExceptionMapper();
    final providerError = FirebaseAuthException(code: 'network-request-failed');
    const mappedError = UnexpectedException(message: 'Custom mapping');
    when(() => mapper.map(providerError)).thenReturn(mappedError);
    when(() => auth.signOut()).thenThrow(providerError);
    await container.unregister<AuthExceptionMapper>();
    container.registerSingleton<AuthExceptionMapper>(mapper);

    await expectLater(
      container.get<AuthRepository>().signOut(),
      throwsA(same(mappedError)),
    );
    verify(() => mapper.map(providerError)).called(1);
  });

  test('reset closes the cubit and a fresh setup has isolated state', () async {
    final oldCubit = container.get<ThemeCubit>();
    final oldRouter = container.get<GoRouter>();
    final oldAuthCubit = container.get<AuthCubit>();
    oldCubit.toggle();
    expect(oldCubit.state, ThemeMode.dark);
    await container.reset();
    expect(oldCubit.isClosed, isTrue);
    expect(oldAuthCubit.isClosed, isTrue);
    expect(container.isRegistered<AuthCubit>(), isFalse);
    expect(container.isRegistered<GoRouter>(), isFalse);
    _DependencyRegistrar().registerDependencies(container);
    await container.unregister<FirebaseFirestore>();
    container.registerSingleton<FirebaseFirestore>(FakeFirebaseFirestore());
    await container.unregister<FirebaseAuth>();
    container.registerSingleton<FirebaseAuth>(auth);
    expect(container.get<ThemeCubit>(), isNot(same(oldCubit)));
    expect(container.get<ThemeCubit>().state, ThemeMode.light);
    expect(container.get<GoRouter>(), isNot(same(oldRouter)));
  });
}

final class _DependencyRegistrar with AppDependencyRegisterMixin {}

final class _TestService {}

class _MockAuthExceptionMapper extends Mock implements AuthExceptionMapper {}
