import 'package:clinic_appointment_system/core/di/app_dependency_register_mixin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

/// Initializes core bindings and services before running the application.
final class AppInitializer with AppDependencyRegisterMixin {
  const AppInitializer(this.container);

  final GetIt container;

  /// Runs pre-app-start initialization tasks.
  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    registerDependencies(container);
  }
}
