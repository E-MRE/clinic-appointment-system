import 'package:clinic_appointment_system/core/di/injector/dependency_injector.dart';

typedef RegisterDependenciesFunction =
    void Function(DependencyInjector injector);

/// The `DependencyInjectionService` class is responsible for managing and providing dependencies in an
/// application.
abstract class DependencyInjectionService {
  const DependencyInjectionService({required this.injector});

  /// The  `injector` variable is used to store an instance of the
  /// `DependencyInjector` class, which is responsible for managing and providing dependencies in the
  /// application. By declaring it as `final`, it means that once the `injector` variable is assigned a
  /// value, it cannot be changed or reassigned.
  final DependencyInjector injector;

  /// The `register` method is a function that allows for registering dependencies in the
  /// `DependencyInjectionService`. It takes an optional parameter `customInjections` of type
  /// `RegisterDependenciesFunction`. Use this parameter for project specific registrations.
  void register({RegisterDependenciesFunction? customInjections});
}
