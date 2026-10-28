import 'package:clinic_appointment_system/core/di/get_it/get_it_dependency_injection_manager.dart';
import 'package:clinic_appointment_system/core/di/injector/dependency_injector.dart';

/// Exposes the application's registered dependencies to screen-owned providers.
final class AppDependency {
  /// Resolves dependencies from the shared container.
  static DependencyInjector get injector =>
      GetItDependencyInjectionManager().injector;
}
