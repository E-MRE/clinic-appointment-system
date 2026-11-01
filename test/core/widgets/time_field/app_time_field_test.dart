import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/widgets/time_field/app_time_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/localization_test_app.dart';

void main() {
  testWidgets('time field displays hint, opens picker and returns a time', (
    tester,
  ) async {
    ClockTime? selected;
    await loadTestTranslations(
      tester,
      child: Scaffold(
        body: AppTimeField(
          label: 'Time',
          value: null,
          hint: 'Choose',
          onChanged: (value) {
            selected = value;
          },
        ),
      ),
    );
    expect(find.text('Choose'), findsOneWidget);
    await tester.tap(find.text('Choose'));
    await tester.pumpAndSettle();
    expect(find.byType(TimePickerDialog), findsOneWidget);
    await tester.tap(find.byIcon(Icons.keyboard_outlined));
    await tester.pumpAndSettle();
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '14');
    await tester.enterText(fields.at(1), '30');
    await tester.tap(find.text('Tamam'));
    await tester.pumpAndSettle();
    expect(selected, ClockTime(hour: 14, minute: 30));
  });

  testWidgets('disabled field displays value and does not open', (
    tester,
  ) async {
    await loadTestTranslations(
      tester,
      child: Scaffold(
        body: AppTimeField(
          label: 'Time',
          value: ClockTime(hour: 9, minute: 30),
          enabled: false,
          onChanged: (_) {},
        ),
      ),
    );
    expect(find.text('09:30'), findsOneWidget);
    await tester.tap(find.text('09:30'));
    await tester.pumpAndSettle();
    expect(find.byType(TimePickerDialog), findsNothing);
  });

  testWidgets('error field uses error decoration', (tester) async {
    await loadTestTranslations(
      tester,
      child: Scaffold(
        body: AppTimeField(
          label: 'Time',
          value: null,
          hasError: true,
          onChanged: (_) {},
        ),
      ),
    );
    expect(
      tester
          .widget<InputDecorator>(find.byType(InputDecorator))
          .decoration
          .enabledBorder,
      isNotNull,
    );
  });
}
