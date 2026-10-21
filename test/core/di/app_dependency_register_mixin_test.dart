import 'package:clinic_appointment_system/core/di/app_dependency_register_mixin.dart';
import 'package:clinic_appointment_system/core/di/get_it/get_it_dependency_injection_manager.dart';
import 'package:clinic_appointment_system/core/di/injector/dependency_injector.dart';
import 'package:clinic_appointment_system/core/errors/app_exception.dart';
import 'package:clinic_appointment_system/core/states/theme_cubit.dart';
import 'package:clinic_appointment_system/features/auth/data/mappers/firebase_auth_exception_mapper.dart';
import 'package:clinic_appointment_system/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:clinic_appointment_system/features/auth/domain/mappers/auth_exception_mapper.dart';
import 'package:clinic_appointment_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../support/firebase_auth_doubles.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late DependencyInjector container;
  late MockFirebaseAuth auth;

  setUp(() async {
    final dependency = GetItDependencyInjectionManager();
    container = dependency.injector;
    await container.reset();
    dependency.register(
      customInjections: _DependencyRegistrar().registerDependencies,
    );
    await container.unregister<FirebaseAuth>();
    auth = MockFirebaseAuth();
    when(() => auth.authStateChanges()).thenAnswer((_) => const Stream.empty());
    container.registerSingleton<FirebaseAuth>(auth);
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
    final repository = container.get<AuthRepository>();
    expect(repository, isA<FirebaseAuthRepository>());
    expect(container.get<AuthRepository>(), same(repository));
    expect(container.get<FirebaseAuth>(), same(auth));
    final mapper = container.get<AuthExceptionMapper>();
    expect(mapper, isA<FirebaseAuthExceptionMapper>());
    expect(container.get<AuthExceptionMapper>(), same(mapper));
    final authCubit = container.get<AuthCubit>();
    expect(container.get<AuthCubit>(), same(authCubit));
  });

  test('auth repository uses the injected Firebase instance', () async {
    when(() => auth.authStateChanges()).thenAnswer((_) => Stream.value(null));
    final result = await container
        .get<AuthRepository>()
        .authStateChanges()
        .first;
    expect(result.isSuccess, isTrue);
    expect(result.data, isNull);
    verify(() => auth.authStateChanges()).called(1);
  });

  test('repository uses the mapper registered through its interface', () async {
    final mapper = _MockAuthExceptionMapper();
    final providerError = FirebaseAuthException(code: 'network-request-failed');
    const mappedError = UnexpectedException(message: 'Custom mapping');
    when(() => mapper.map(providerError)).thenReturn(mappedError);
    when(() => auth.signOut()).thenThrow(providerError);
    await container.unregister<AuthExceptionMapper>();
    container.registerSingleton<AuthExceptionMapper>(mapper);

    await expectLater(
      container.get<AuthRepository>().signOut(),
      throwsA(same(mappedError)),
    );
    verify(() => mapper.map(providerError)).called(1);
  });

  test('reset closes the cubit and a fresh setup has isolated state', () async {
    final oldCubit = container.get<ThemeCubit>();
    final oldRouter = container.get<GoRouter>();
    final oldAuthCubit = container.get<AuthCubit>();
    oldCubit.toggle();
    expect(oldCubit.state, ThemeMode.dark);
    await container.reset();
    expect(oldCubit.isClosed, isTrue);
    expect(oldAuthCubit.isClosed, isTrue);
    expect(container.isRegistered<AuthCubit>(), isFalse);
    expect(container.isRegistered<GoRouter>(), isFalse);
    _DependencyRegistrar().registerDependencies(container);
    expect(container.get<ThemeCubit>(), isNot(same(oldCubit)));
    expect(container.get<ThemeCubit>().state, ThemeMode.light);
    expect(container.get<GoRouter>(), isNot(same(oldRouter)));
  });
}

final class _DependencyRegistrar with AppDependencyRegisterMixin {}

final class _TestService {}

class _MockAuthExceptionMapper extends Mock implements AuthExceptionMapper {}
