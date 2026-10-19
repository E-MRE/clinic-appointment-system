import 'package:clinic_appointment_system/core/di/app_dependency_register_mixin.dart';
import 'package:clinic_appointment_system/core/di/get_it/get_it_dependency_injection_manager.dart';
import 'package:clinic_appointment_system/core/di/injector/dependency_injector.dart';
import 'package:clinic_appointment_system/core/states/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late DependencyInjector container;

  setUp(() async {
    final dependency = GetItDependencyInjectionManager();
    container = dependency.injector;
    await container.reset();
    dependency.register(
      customInjections: _DependencyRegistrar().registerDependencies,
    );
  });
  tearDown(() => container.reset());

  test(
    'factory registrations create separate instances and can be removed',
    () async {
      container.registerFactory<_TestService>(
        _TestService.new,
        instanceName: 'factory',
      );
      expect(
        container.get<_TestService>(instanceName: 'factory'),
        isNot(same(container.get<_TestService>(instanceName: 'factory'))),
      );
      await container.unregister<_TestService>(instanceName: 'factory');
      expect(
        container.isRegistered<_TestService>(instanceName: 'factory'),
        isFalse,
      );
    },
  );

  test(
    'lazy reset awaits cleanup and recreates the service on next access',
    () async {
      var disposals = 0;
      container.registerLazySingleton<_TestService>(
        _TestService.new,
        instanceName: 'lazy',
        dispose: (_) async {
          disposals++;
        },
      );
      final original = container.get<_TestService>(instanceName: 'lazy');
      await container.resetLazySingleton<_TestService>(instanceName: 'lazy');
      expect(disposals, 1);
      expect(
        container.get<_TestService>(instanceName: 'lazy'),
        isNot(same(original)),
      );
      await container.unregister<_TestService>(instanceName: 'lazy');
      expect(disposals, 2);
    },
  );

  test('every registered type resolves and app services are shared', () {
    final cubit = container.get<ThemeCubit>();
    final router = container.get<GoRouter>();
    expect(container.get<ThemeCubit>(), same(cubit));
    expect(container.get<GoRouter>(), same(router));
    expect(cubit.state, ThemeMode.light);
  });

  test('reset closes the cubit and a fresh setup has isolated state', () async {
    final oldCubit = container.get<ThemeCubit>();
    final oldRouter = container.get<GoRouter>();
    oldCubit.toggle();
    expect(oldCubit.state, ThemeMode.dark);
    await container.reset();
    expect(oldCubit.isClosed, isTrue);
    expect(container.isRegistered<GoRouter>(), isFalse);
    _DependencyRegistrar().registerDependencies(container);
    expect(container.get<ThemeCubit>(), isNot(same(oldCubit)));
    expect(container.get<ThemeCubit>().state, ThemeMode.light);
    expect(container.get<GoRouter>(), isNot(same(oldRouter)));
  });
}

final class _DependencyRegistrar with AppDependencyRegisterMixin {}

final class _TestService {}
