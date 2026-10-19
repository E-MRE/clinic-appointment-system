import 'package:clinic_appointment_system/app.dart';
import 'package:clinic_appointment_system/app_initializer.dart';
import 'package:clinic_appointment_system/core/states/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

void main() async {
  final container = GetIt.asNewInstance();
  await AppInitializer(container).initialize();
  runApp(
    App(router: container<GoRouter>(), themeCubit: container<ThemeCubit>()),
  );
}
