import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

/// Initializes core bindings and services before running the application.
final class AppInitializer {
  const AppInitializer();

  /// Runs pre-app-start initialization tasks.
  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
  }
}
