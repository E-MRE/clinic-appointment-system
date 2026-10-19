import 'package:clinic_appointment_system/app.dart';
import 'package:clinic_appointment_system/app_initializer.dart';
import 'package:clinic_appointment_system/core/di/configure_dependencies.dart';
import 'package:clinic_appointment_system/core/states/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

void main() async {
  await const AppInitializer().initialize();
  final container = GetIt.asNewInstance();
  configureDependencies(container);
  runApp(
    App(router: container<GoRouter>(), themeCubit: container<ThemeCubit>()),
  );
}
