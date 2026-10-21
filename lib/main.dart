import 'package:clinic_appointment_system/app.dart';
import 'package:clinic_appointment_system/app_initializer.dart';
import 'package:clinic_appointment_system/core/di/get_it/get_it_dependency_injection_manager.dart';
import 'package:clinic_appointment_system/core/states/theme_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() async {
  final dependency = GetItDependencyInjectionManager();
  await AppInitializer(dependency).initialize();
  runApp(
    App(
      router: dependency.injector.get<GoRouter>(),
      themeCubit: dependency.injector.get<ThemeCubit>(),
      authCubit: dependency.injector.get<AuthCubit>(),
    ),
  );
}
