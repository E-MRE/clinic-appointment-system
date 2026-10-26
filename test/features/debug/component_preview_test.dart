import 'package:clinic_appointment_system/core/router/app_router.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/features/debug/presentation/pages/component_preview/component_preview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../support/localization_test_app.dart';

void main() {
  test('debug route registration follows the injected flag', () {
    final enabled = createAppRouter(enableDebugRoutes: true);
    final disabled = createAppRouter(enableDebugRoutes: false);
    bool containsPreview(GoRouter router) {
      return router.configuration.routes.whereType<GoRoute>().any(
        (route) => route.path == AppRoutes.componentPreview,
      );
    }

    expect(containsPreview(enabled), isTrue);
    expect(containsPreview(disabled), isFalse);
    enabled.dispose();
    disabled.dispose();
  });

  testWidgets('catalogue renders every section', (tester) async {
    await loadTestTranslations(
      tester,
      child: const ComponentPreviewPage(),
      theme: LightTheme(ScreenSize.mobile).themeData,
    );
    final scrollable = find
        .descendant(
          of: find.byType(ComponentPreviewPage),
          matching: find.byType(Scrollable),
        )
        .at(1);
    for (final section in [
      'text',
      'surface',
      'status',
      'header',
      'states',
      'loading',
      'list',
      'avatar',
      'fields',
      'choices',
      'navigation',
      'other',
    ]) {
      final target = find.byKey(ValueKey(section));
      await tester.scrollUntilVisible(target, 400, scrollable: scrollable);
      expect(target, findsOneWidget);
    }
  });
  testWidgets('role and tone matrix follows local theme and width', (
    tester,
  ) async {
    await loadTestTranslations(
      tester,
      child: const ComponentPreviewPage(),
      theme: LightTheme(ScreenSize.mobile).themeData,
    );
    for (final role in TextRole.values) {
      for (final tone in TextTone.values) {
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is AppText &&
                widget.role == role &&
                widget.tone == tone &&
                widget.data == '${role.name} / ${tone.name}',
          ),
          findsOneWidget,
        );
      }
    }
    await tester.tap(
      find.byWidgetPredicate((widget) => widget is DropdownButton).last,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Koyu').last);
    await tester.pumpAndSettle();
    final sample = find.text('display / normal');
    expect(Theme.of(tester.element(sample)).brightness, Brightness.dark);
    await tester.tap(
      find.byWidgetPredicate((widget) => widget is DropdownButton).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mobil').last);
    await tester.pumpAndSettle();
    expect(
      MediaQuery.sizeOf(tester.element(sample)).width,
      AppSizes.previewMobileWidth,
    );
  });
}
