import 'package:clinic_appointment_system/core/di/injector/dependency_injector.dart';
import 'package:clinic_appointment_system/core/router/app_router.dart';
import 'package:clinic_appointment_system/core/states/theme_cubit.dart';
import 'package:clinic_appointment_system/features/auth/data/mappers/firebase_auth_exception_mapper.dart';
import 'package:clinic_appointment_system/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:clinic_appointment_system/features/auth/domain/mappers/auth_exception_mapper.dart';
import 'package:clinic_appointment_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

/// Register once per container. Only the composition root resolves services.
/// The container owns these app-lifetime objects and disposes them on reset.
mixin AppDependencyRegisterMixin {
  void registerDependencies(DependencyInjector injector) {
    // FirebaseApp owns this SDK instance; container reset must not delete it.
    injector.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    injector.registerLazySingleton<AuthExceptionMapper>(
      FirebaseAuthExceptionMapper.new,
    );
    injector.registerLazySingleton<AuthRepository>(
      () => FirebaseAuthRepository(
        injector.get<FirebaseAuth>(),
        injector.get<AuthExceptionMapper>(),
      ),
    );
    injector.registerLazySingleton<ThemeCubit>(
      ThemeCubit.new,
      dispose: (cubit) => cubit.close(),
    );
    injector.registerLazySingleton<AuthCubit>(
      () => AuthCubit(injector.get<AuthRepository>()),
      dispose: (cubit) => cubit.close(),
    );
    // Each screen owns and closes its request cubit.
    injector.registerFactory<SignInCubit>(
      () => SignInCubit(injector.get<AuthRepository>()),
    );
    injector.registerFactory<SignUpCubit>(
      () => SignUpCubit(injector.get<AuthRepository>()),
    );
    injector.registerFactory<PasswordResetCubit>(
      () => PasswordResetCubit(injector.get<AuthRepository>()),
    );
    injector.registerLazySingleton<GoRouter>(
      createAppRouter,
      dispose: (router) => router.dispose(),
    );
  }
}
