import 'package:clinic_appointment_system/app.dart';
import 'package:clinic_appointment_system/core/constants/widget_key.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/router/app_router.dart';
import 'package:clinic_appointment_system/core/states/theme_cubit.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'support/auth_repository_doubles.dart';

void main() {
  late GoRouter router;
  late ThemeCubit themeCubit;
  late AuthCubit authCubit;
  setUp(() {
    router = createAppRouter();
    themeCubit = ThemeCubit();
    final repository = MockAuthRepository();
    when(() => repository.authStateChanges()).thenAnswer(
      (_) => Stream.value(const DataResult<AuthSession>.success(data: null)),
    );
    authCubit = AuthCubit(repository);
  });
  tearDown(() async {
    router.dispose();
    await themeCubit.close();
    await authCubit.close();
  });

  testWidgets('unknown deep link shows not found and can return home', (
    tester,
  ) async {
    router.dispose();
    router = createAppRouter(initialLocation: '/missing/nested?source=test');
    await tester.pumpWidget(
      App(router: router, themeCubit: themeCubit, authCubit: authCubit),
    );
    await tester.pumpAndSettle();
    expect(find.text('Sayfa bulunamadı'), findsOneWidget);
    await tester.tap(find.text('Ana sayfaya dön'));
    await tester.pumpAndSettle();
    expect(find.text('Klinik Randevu Sistemi'), findsOneWidget);
    expect(router.routeInformationProvider.value.uri.path, '/');
  });

  testWidgets('shows the clinic appointment system title', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      App(router: router, themeCubit: themeCubit, authCubit: authCubit),
    );
    await tester.pumpAndSettle();

    expect(find.text('Klinik Randevu Sistemi'), findsOneWidget);
    final context = tester.element(find.byType(MaterialApp));
    expect(context.read<AuthCubit>(), same(authCubit));
    expect(authCubit.state, isA<AuthSignedOut>());
  });

  testWidgets('theme toggle switches between light and dark', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      App(router: router, themeCubit: themeCubit, authCubit: authCubit),
    );
    await tester.pumpAndSettle();
    MaterialApp app() => tester.widget<MaterialApp>(find.byType(MaterialApp));

    expect(app().themeMode, ThemeMode.light);

    await tester.tap(find.byKey(const WidgetKey.themeToggleKey()));
    await tester.pump();
    expect(app().themeMode, ThemeMode.dark);

    await tester.tap(find.byKey(const WidgetKey.themeToggleKey()));
    await tester.pump();
    expect(app().themeMode, ThemeMode.light);
  });
}
