import 'package:clinic_appointment_system/core/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/widget_test_host.dart';

void main() {
  testWidgets('renders every status variant in dark theme at text scale 2', (
    tester,
  ) async {
    const variants = StatusBadgeVariant.values;
    await tester.pumpWidget(
      widgetTestHost(
        Wrap(
          children: [
            for (final variant in variants)
              StatusBadge(label: variant.name, variant: variant),
          ],
        ),
        brightness: Brightness.dark,
        textScale: 2,
      ),
    );
    for (final variant in variants) {
      expect(find.text(variant.name), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });
}
