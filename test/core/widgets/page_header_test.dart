import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/widget_test_host.dart';

void main() {
  testWidgets('supports each tier in dark theme at text scale 2', (
    tester,
  ) async {
    for (final size in ScreenSize.values) {
      final dimensions = switch (size) {
        ScreenSize.mobile => const Size(390, 844),
        ScreenSize.tablet => const Size(834, 1112),
        ScreenSize.desktop => const Size(1440, 1000),
      };
      await tester.pumpWidget(
        widgetTestHost(
          const PageHeader(
            title: 'Appointments',
            subtitle: 'Upcoming and recently completed visits',
            actions: Icon(Icons.notifications),
          ),
          brightness: Brightness.dark,
          size: dimensions,
          textScale: 2,
        ),
      );
      expect(find.text('Appointments'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}
