import 'package:clinic_appointment_system/core/di/injector/dependency_injector.dart';
import 'package:clinic_appointment_system/core/router/app_router.dart';
import 'package:clinic_appointment_system/core/states/theme_cubit.dart';
import 'package:go_router/go_router.dart';

/// Register once per container. Only the composition root resolves services.
/// The container owns these app-lifetime objects and disposes them on reset.
mixin AppDependencyRegisterMixin {
  void registerDependencies(DependencyInjector injector) {
    injector.registerLazySingleton<ThemeCubit>(
      ThemeCubit.new,
      dispose: (cubit) => cubit.close(),
    );
    injector.registerLazySingleton<GoRouter>(
      createAppRouter,
      dispose: (router) => router.dispose(),
    );
  }
}
