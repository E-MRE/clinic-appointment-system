import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/features/admin/presentation/widgets/admin_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../../support/localization_test_app.dart';

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

    expect(find.text('Hizmetler'), findsOneWidget);
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
}
