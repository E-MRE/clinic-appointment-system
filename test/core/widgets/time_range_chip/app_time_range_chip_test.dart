import 'package:clinic_appointment_system/core/widgets/time_range_chip/app_time_range_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../support/localization_test_app.dart';

void main() {
  testWidgets('chip exposes its remove action and flagged theme color', (
    tester,
  ) async {
    bool removed = false;
    await loadTestTranslations(
      tester,
      child: Scaffold(
        body: AppTimeRangeChip(
          label: '09:00–12:00',
          removeTooltip: 'Remove',
          variant: AppTimeRangeChipVariant.flagged,
          onRemove: () {
            removed = true;
          },
        ),
      ),
    );
    expect(find.text('09:00–12:00'), findsOneWidget);
    expect(find.byTooltip('Remove'), findsOneWidget);
    final container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(AppTimeRangeChip),
            matching: find.byType(Container),
          )
          .first,
    );
    final scheme = Theme.of(
      tester.element(find.byType(AppTimeRangeChip)),
    ).colorScheme;
    expect(
      (container.decoration as BoxDecoration).color,
      scheme.errorContainer,
    );
    await tester.tap(find.byTooltip('Remove'));
    expect(removed, isTrue);
    await loadTestTranslations(
      tester,
      child: const Scaffold(
        body: AppTimeRangeChip(
          label: 'Range',
          removeTooltip: 'Remove',
          onRemove: null,
        ),
      ),
    );
    expect(find.byTooltip('Remove'), findsNothing);
  });
}
