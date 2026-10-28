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
import 'package:clinic_appointment_system/features/users/data/models/user_model_factory.dart';
import 'package:clinic_appointment_system/features/users/data/repositories/firestore_user_repository.dart';
import 'package:clinic_appointment_system/features/users/domain/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

/// Register once per container. Only the composition root resolves services.
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
    injector.registerLazySingleton<AuthRouteGuard>(
      () => AuthRouteGuard(injector.get<AuthCubit>()),
      dispose: (guard) => guard.dispose(),
    );
    injector.registerLazySingleton<GoRouter>(
      () {
        return createAppRouter(
          authGuard: injector.get<AuthRouteGuard>(),
          signInCubitFactory: injector.get<SignInCubit>,
          signUpCubitFactory: injector.get<SignUpCubit>,
          passwordResetCubitFactory: injector.get<PasswordResetCubit>,
        );
      },
      dispose: (router) {
        router.dispose();
      },
    );
  }
}
