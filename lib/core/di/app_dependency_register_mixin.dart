import 'package:clinic_appointment_system/core/di/injector/dependency_injector.dart';
import 'package:clinic_appointment_system/core/router/app_router.dart';
import 'package:clinic_appointment_system/core/states/theme_cubit.dart';
import 'package:clinic_appointment_system/features/auth/data/mappers/firebase_auth_exception_mapper.dart';
import 'package:clinic_appointment_system/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:clinic_appointment_system/features/auth/domain/mappers/auth_exception_mapper.dart';
import 'package:clinic_appointment_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/register_patient_use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/send_password_reset_email_use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/watch_session_use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/watch_user_profile_use_case.dart';
import 'package:clinic_appointment_system/features/auth/presentation/auth_route_guard.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
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
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_filter_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_list_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_save_cubit.dart';
import 'package:clinic_appointment_system/features/users/data/models/user_model_factory.dart';
import 'package:clinic_appointment_system/features/users/data/repositories/firestore_user_repository.dart';
import 'package:clinic_appointment_system/features/users/domain/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

/// Registers services once per container for the application and its screens.
/// The container owns these app-lifetime objects and disposes them on reset.
mixin AppDependencyRegisterMixin {
  void registerDependencies(DependencyInjector injector) {
    // FirebaseApp owns this SDK instance; container reset must not delete it.
    injector.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    injector.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
    injector.registerLazySingleton<UserRepository>(
      () => FirestoreUserRepository(
        injector.get<FirebaseFirestore>(),
        const UserModelFactory(),
      ),
    );
    injector.registerLazySingleton<ClinicRepository>(
      () => FirestoreClinicRepository(injector.get<FirebaseFirestore>()),
    );
    injector.registerLazySingleton<BranchRepository>(
      () => FirestoreBranchRepository(injector.get<FirebaseFirestore>()),
    );
    injector.registerLazySingleton<DepartmentRepository>(
      () => FirestoreDepartmentRepository(injector.get<FirebaseFirestore>()),
    );
    injector.registerLazySingleton<MedicalServiceModelFactory>(
      () => const MedicalServiceModelFactory(),
    );
    injector.registerLazySingleton<MedicalServiceRepository>(
      () => FirestoreMedicalServiceRepository(
        injector.get<FirebaseFirestore>(),
        injector.get<MedicalServiceModelFactory>(),
      ),
    );
    injector.registerLazySingleton<WatchClinicsUseCase>(
      () => WatchClinicsUseCase(injector.get<ClinicRepository>()),
    );
    injector.registerLazySingleton<CreateClinicUseCase>(
      () => CreateClinicUseCase(injector.get<ClinicRepository>()),
    );
    injector.registerLazySingleton<UpdateClinicUseCase>(
      () => UpdateClinicUseCase(injector.get<ClinicRepository>()),
    );
    injector.registerLazySingleton<WatchBranchesUseCase>(
      () => WatchBranchesUseCase(injector.get<BranchRepository>()),
    );
    injector.registerLazySingleton<CreateBranchUseCase>(
      () => CreateBranchUseCase(injector.get<BranchRepository>()),
    );
    injector.registerLazySingleton<UpdateBranchUseCase>(
      () => UpdateBranchUseCase(injector.get<BranchRepository>()),
    );
    injector.registerLazySingleton<WatchDepartmentsUseCase>(
      () => WatchDepartmentsUseCase(injector.get<DepartmentRepository>()),
    );
    injector.registerLazySingleton<CreateDepartmentUseCase>(
      () => CreateDepartmentUseCase(injector.get<DepartmentRepository>()),
    );
    injector.registerLazySingleton<UpdateDepartmentUseCase>(
      () => UpdateDepartmentUseCase(injector.get<DepartmentRepository>()),
    );
    injector.registerLazySingleton<WatchMedicalServicesUseCase>(
      () =>
          WatchMedicalServicesUseCase(injector.get<MedicalServiceRepository>()),
    );
    injector.registerLazySingleton<CreateMedicalServiceUseCase>(
      () =>
          CreateMedicalServiceUseCase(injector.get<MedicalServiceRepository>()),
    );
    injector.registerLazySingleton<UpdateMedicalServiceUseCase>(
      () =>
          UpdateMedicalServiceUseCase(injector.get<MedicalServiceRepository>()),
    );
    injector.registerLazySingleton<AuthExceptionMapper>(
      FirebaseAuthExceptionMapper.new,
    );
    injector.registerLazySingleton<AuthRepository>(() {
      return FirebaseAuthRepository(
        injector.get<FirebaseAuth>(),
        injector.get<AuthExceptionMapper>(),
      );
    });
    injector.registerLazySingleton<SignInUseCase>(
      () => SignInUseCase(injector.get<AuthRepository>()),
    );
    injector.registerLazySingleton<RegisterPatientUseCase>(
      () => RegisterPatientUseCase(
        injector.get<AuthRepository>(),
        injector.get<UserRepository>(),
      ),
    );
    injector.registerLazySingleton<SendPasswordResetEmailUseCase>(
      () => SendPasswordResetEmailUseCase(injector.get<AuthRepository>()),
    );
    injector.registerLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(injector.get<AuthRepository>()),
    );
    injector.registerLazySingleton<WatchSessionUseCase>(
      () => WatchSessionUseCase(injector.get<AuthRepository>()),
    );
    injector.registerLazySingleton<WatchUserProfileUseCase>(
      () => WatchUserProfileUseCase(injector.get<UserRepository>()),
    );
    injector.registerLazySingleton<ThemeCubit>(
      ThemeCubit.new,
      dispose: (cubit) => cubit.close(),
    );
    injector.registerLazySingleton<AuthCubit>(
      () => AuthCubit(
        injector.get<WatchSessionUseCase>(),
        injector.get<WatchUserProfileUseCase>(),
        injector.get<SignOutUseCase>(),
      ),
      dispose: (cubit) => cubit.close(),
    );
    // Each screen owns and closes its request cubit.
    injector.registerFactory<SignInCubit>(
      () => SignInCubit(injector.get<SignInUseCase>()),
    );
    injector.registerFactory<SignUpCubit>(
      () => SignUpCubit(injector.get<RegisterPatientUseCase>()),
    );
    injector.registerFactory<PasswordResetCubit>(
      () => PasswordResetCubit(injector.get<SendPasswordResetEmailUseCase>()),
    );
    injector.registerFactory<ClinicListCubit>(
      () => ClinicListCubit(injector.get<WatchClinicsUseCase>()),
    );
    injector.registerFactory<BranchListCubit>(
      () => BranchListCubit(injector.get<WatchBranchesUseCase>()),
    );
    injector.registerFactory<DepartmentListCubit>(
      () => DepartmentListCubit(injector.get<WatchDepartmentsUseCase>()),
    );
    injector.registerFactory<ClinicSaveCubit>(
      () => ClinicSaveCubit(
        injector.get<CreateClinicUseCase>(),
        injector.get<UpdateClinicUseCase>(),
      ),
    );
    injector.registerFactory<BranchSaveCubit>(
      () => BranchSaveCubit(
        injector.get<CreateBranchUseCase>(),
        injector.get<UpdateBranchUseCase>(),
      ),
    );
    injector.registerFactory<DepartmentSaveCubit>(
      () => DepartmentSaveCubit(
        injector.get<CreateDepartmentUseCase>(),
        injector.get<UpdateDepartmentUseCase>(),
      ),
    );
    injector.registerFactory<MedicalServiceListCubit>(
      () =>
          MedicalServiceListCubit(injector.get<WatchMedicalServicesUseCase>()),
    );
    injector.registerFactory<MedicalServiceSaveCubit>(
      () => MedicalServiceSaveCubit(
        injector.get<CreateMedicalServiceUseCase>(),
        injector.get<UpdateMedicalServiceUseCase>(),
      ),
    );
    injector.registerFactory<MedicalServiceFilterCubit>(
      MedicalServiceFilterCubit.new,
    );
    injector.registerFactory<WorkingHoursEditorCubit>(
      WorkingHoursEditorCubit.new,
    );
    injector.registerLazySingleton<AuthRouteGuard>(
      () => AuthRouteGuard(injector.get<AuthCubit>()),
      dispose: (guard) => guard.dispose(),
    );
    injector.registerLazySingleton<GoRouter>(
      () {
        return createAppRouter(authGuard: injector.get<AuthRouteGuard>());
      },
      dispose: (router) {
        router.dispose();
      },
    );
  }
}
