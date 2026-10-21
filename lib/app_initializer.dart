import 'package:clinic_appointment_system/core/di/app_dependency_register_mixin.dart';
import 'package:clinic_appointment_system/core/di/injector/dependency_injection_service.dart';
import 'package:clinic_appointment_system/firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

/// Initializes core bindings and services before running the application.
final class AppInitializer with AppDependencyRegisterMixin {
  const AppInitializer(this.dependency);

  final DependencyInjectionService dependency;

  /// Runs pre-app-start initialization tasks.
  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await EasyLocalization.ensureInitialized();
    dependency.register(customInjections: registerDependencies);
  }
}
