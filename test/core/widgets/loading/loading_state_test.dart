import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state_variant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/widget_test_host.dart';

void main() {
  testWidgets('renders every variant in dark theme at text scale 2', (
    tester,
  ) async {
    for (final variant in LoadingStateVariant.values) {
      await tester.pumpWidget(
        widgetTestHost(
          LoadingState(variant: variant, label: 'Loading appointments'),
          brightness: Brightness.dark,
          textScale: 2,
        ),
      );
      expect(find.byType(LoadingState), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}
