import 'package:clinic_appointment_system/core/widgets/state/error_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/widget_test_host.dart';

void main() {
  testWidgets('supports dark theme, large text, long copy and both actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      widgetTestHost(
        const ErrorState(
          title: 'Service temporarily unavailable',
          message:
              'Please try again later. If this keeps happening, contact the clinic support team for help restoring access to your appointments.',
          icon: Icon(Icons.error_outline),
          iconBackground: Colors.red,
          primaryAction: Text('Retry'),
          secondaryAction: Text('Go home'),
        ),
        brightness: Brightness.dark,
        textScale: 2,
      ),
    );
    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('Go home'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.header == true,
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
