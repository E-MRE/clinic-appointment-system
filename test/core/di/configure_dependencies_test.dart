import 'package:clinic_appointment_system/core/di/configure_dependencies.dart';
import 'package:clinic_appointment_system/core/states/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late GetIt container;

  setUp(() {
    container = GetIt.asNewInstance();
    configureDependencies(container);
  });
  tearDown(() => container.reset());

  test('every registered type resolves and app services are shared', () {
    final cubit = container<ThemeCubit>();
    final router = container<GoRouter>();
    expect(container<ThemeCubit>(), same(cubit));
    expect(container<GoRouter>(), same(router));
    expect(cubit.state, ThemeMode.light);
  });

  test('reset closes the cubit and a fresh setup has isolated state', () async {
    final oldCubit = container<ThemeCubit>();
    final oldRouter = container<GoRouter>();
    oldCubit.toggle();
    expect(oldCubit.state, ThemeMode.dark);
    await container.reset();
    expect(oldCubit.isClosed, isTrue);
    expect(container.isRegistered<GoRouter>(), isFalse);
    configureDependencies(container);
    expect(container<ThemeCubit>(), isNot(same(oldCubit)));
    expect(container<ThemeCubit>().state, ThemeMode.light);
    expect(container<GoRouter>(), isNot(same(oldRouter)));
  });
}
