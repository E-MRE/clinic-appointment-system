import 'package:clinic_appointment_system/core/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/widget_test_host.dart';

void main() {
  testWidgets('supports dark theme, large text, long copy and both actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      widgetTestHost(
        const EmptyState(
          title: 'There are no appointments yet',
          message:
              'Appointments you book will appear here. You can browse available clinicians and choose a time that works for you.',
          icon: Icon(Icons.event_note),
          iconBackground: Colors.blue,
          primaryAction: Text('Book appointment'),
          secondaryAction: Text('Learn more'),
        ),
        brightness: Brightness.dark,
        textScale: 2,
      ),
    );
    expect(find.text('Book appointment'), findsOneWidget);
    expect(find.text('Learn more'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.header == true,
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
