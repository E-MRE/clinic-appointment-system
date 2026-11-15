import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/features/admin/presentation/widgets/admin_shell.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/admin.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../support/auth_cubit_factory.dart';
import '../../../../support/auth_repository_doubles.dart';
import '../../../../support/localization_test_app.dart';
import '../../../../support/user_repository_double.dart';

void main() {
  testWidgets('tapping Hizmetler navigates to services route', (tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.adminHome,
      routes: [
        ShellRoute(
          builder: (context, state, child) => AdminShell(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.adminHome,
              builder: (context, state) => const Text('Overview Page'),
            ),
            GoRoute(
              path: AppRoutes.adminAppointments,
              builder: (context, state) => const Text('Appointments Page'),
            ),
            GoRoute(
              path: AppRoutes.institution,
              builder: (context, state) => const Text('Institution Page'),
            ),
            GoRoute(
              path: AppRoutes.services,
              builder: (context, state) => const Text('Services Page'),
            ),
            GoRoute(
              path: AppRoutes.adminStaff,
              builder: (context, state) => const Text('Staff Page'),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);

    await loadTestTranslations(
      tester,
      theme: LightTheme(ScreenSize.mobile).themeData,
      child: MaterialApp.router(routerConfig: router),
    );

    expect(find.text('Kurum ve şubeler'), findsOneWidget);
    expect(find.text('Hizmetler'), findsOneWidget);
    expect(find.text('Randevular'), findsOneWidget);
    await tester.tap(find.text('Randevular'));
    await tester.pumpAndSettle();
    expect(
      router.routeInformationProvider.value.uri.path,
      AppRoutes.adminAppointments,
    );
    expect(find.text('Appointments Page'), findsOneWidget);

    await tester.tap(find.text('Hizmetler'));
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.path, AppRoutes.services);
    expect(find.text('Services Page'), findsOneWidget);
    expect(find.text('Personel'), findsOneWidget);
    await tester.tap(find.text('Personel'));
    await tester.pumpAndSettle();
    expect(
      router.routeInformationProvider.value.uri.path,
      AppRoutes.adminStaff,
    );
    expect(find.text('Staff Page'), findsOneWidget);
  });

  testWidgets('admin footer signs out the authenticated administrator', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = MockAuthRepository();
    final sessions = StreamController<DataResult<AuthSession>>();
    when(
      () => repository.authStateChanges(),
    ).thenAnswer((_) => sessions.stream);
    when(
      () => repository.signOut(),
    ).thenAnswer((_) async => const Result.success());
    final users = TestUserRepository()
      ..getResult = const DataResult<User>.success(
        data: Admin(
          id: 'admin-1',
          fullName: 'Nur Karaca',
          email: 'admin@test.dev',
        ),
      );
    final authCubit = createAuthCubit(repository, users);
    addTearDown(() async {
      await authCubit.close();
      await sessions.close();
    });
    final router = GoRouter(
      initialLocation: AppRoutes.adminHome,
      routes: [
        ShellRoute(
          builder: (context, state, child) => AdminShell(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.adminHome,
              builder: (context, state) => const Text('Overview Page'),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    sessions.add(
      const DataResult.success(
        data: AuthSession(
          userId: 'admin-1',
          email: 'admin@test.dev',
          isEmailVerified: true,
        ),
      ),
    );

    await loadTestTranslations(
      tester,
      theme: LightTheme(ScreenSize.desktop).themeData,
      child: BlocProvider<AuthCubit>.value(
        value: authCubit,
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    expect(find.text('Nur Karaca'), findsOneWidget);
    expect(find.text('Yönetici'), findsOneWidget);
    await tester.tap(find.byTooltip('Çıkış yap'));
    await tester.pump();

    verify(() => repository.signOut()).called(1);
  });
}
