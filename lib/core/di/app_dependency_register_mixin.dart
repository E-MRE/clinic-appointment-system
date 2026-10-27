import 'package:clinic_appointment_system/core/di/injector/dependency_injector.dart';
import 'package:clinic_appointment_system/core/router/app_router.dart';
import 'package:clinic_appointment_system/core/states/theme_cubit.dart';
import 'package:clinic_appointment_system/features/auth/data/mappers/firebase_auth_exception_mapper.dart';
import 'package:clinic_appointment_system/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:clinic_appointment_system/features/auth/domain/mappers/auth_exception_mapper.dart';
import 'package:clinic_appointment_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:clinic_appointment_system/features/auth/presentation/auth_route_guard.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/sign_up_cubit.dart';
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
    injector.registerLazySingleton<AuthExceptionMapper>(
      FirebaseAuthExceptionMapper.new,
    );
    injector.registerLazySingleton<AuthRepository>(() {
      return FirebaseAuthRepository(
        injector.get<FirebaseAuth>(),
        injector.get<AuthExceptionMapper>(),
      );
    });
    injector.registerLazySingleton<ThemeCubit>(
      ThemeCubit.new,
      dispose: (cubit) => cubit.close(),
    );
    injector.registerLazySingleton<AuthCubit>(
      () => AuthCubit(
        injector.get<AuthRepository>(),
        injector.get<UserRepository>(),
      ),
      dispose: (cubit) => cubit.close(),
    );
    // Each screen owns and closes its request cubit.
    injector.registerFactory<SignInCubit>(
      () => SignInCubit(injector.get<AuthRepository>()),
    );
    injector.registerFactory<SignUpCubit>(
      () => SignUpCubit(
        injector.get<AuthRepository>(),
        injector.get<UserRepository>(),
      ),
    );
    injector.registerFactory<PasswordResetCubit>(
      () => PasswordResetCubit(injector.get<AuthRepository>()),
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
