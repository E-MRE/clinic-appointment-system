import 'package:clinic_appointment_system/core/di/get_it/get_it_dependency_injector.dart';
import 'package:clinic_appointment_system/core/di/injector/dependency_injection_service.dart';

final class GetItDependencyInjectionManager extends DependencyInjectionService {
  factory GetItDependencyInjectionManager() => _instance;

  GetItDependencyInjectionManager._internal()
    : super(injector: GetItDependencyInjector());

  static final GetItDependencyInjectionManager _instance =
      GetItDependencyInjectionManager._internal();

  @override
  void register({RegisterDependenciesFunction? customInjections}) {
    customInjections?.call(injector);
  }
}
