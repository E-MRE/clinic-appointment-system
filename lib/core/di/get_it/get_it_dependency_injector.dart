import 'dart:async';

import 'package:clinic_appointment_system/core/di/injector/dependency_injector.dart';
import 'package:get_it/get_it.dart' as get_it;

final class GetItDependencyInjector implements DependencyInjector {
  GetItDependencyInjector() : _injector = get_it.GetIt.instance;

  final get_it.GetIt _injector;

  @override
  T get<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
    Type? type,
  }) {
    return _injector.get<T>(
      instanceName: instanceName,
      param1: param1,
      param2: param2,
      type: type,
    );
  }

  @override
  bool isRegistered<T extends Object>({
    Object? instance,
    String? instanceName,
  }) {
    return _injector.isRegistered<T>(
      instance: instance,
      instanceName: instanceName,
    );
  }

  @override
  void registerFactory<T extends Object>(
    FactoryFunc<T> factoryFunc, {
    String? instanceName,
  }) {
    _injector.registerFactory<T>(factoryFunc, instanceName: instanceName);
  }

  @override
  void registerLazySingleton<T extends Object>(
    FactoryFunc<T> factoryFunc, {
    String? instanceName,
    DisposingFunc<T>? dispose,
  }) {
    _injector.registerLazySingleton<T>(
      factoryFunc,
      instanceName: instanceName,
      dispose: dispose,
    );
  }

  @override
  T registerSingleton<T extends Object>(
    T instance, {
    String? instanceName,
    bool? signalsReady,
    DisposingFunc<T>? dispose,
  }) {
    return _injector.registerSingleton<T>(
      instance,
      instanceName: instanceName,
      signalsReady: signalsReady,
      dispose: dispose,
    );
  }

  @override
  Future<void> reset({bool dispose = true}) async {
    await _injector.reset(dispose: dispose);
  }

  @override
  FutureOr<dynamic> resetLazySingleton<T extends Object>({
    T? instance,
    String? instanceName,
    FutureOr<dynamic> Function(T p1)? disposingFunction,
  }) {
    return _injector.resetLazySingleton<T>(
      instance: instance,
      instanceName: instanceName,
      disposingFunction: disposingFunction,
    );
  }

  @override
  FutureOr<dynamic> unregister<T extends Object>({
    Object? instance,
    String? instanceName,
    FutureOr<dynamic> Function(T p1)? disposingFunction,
  }) {
    return _injector.unregister<T>(
      instance: instance,
      instanceName: instanceName,
      disposingFunction: disposingFunction,
    );
  }
}
