import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/widgets/date_field/app_date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../support/localization_test_app.dart';

void main() {
  testWidgets('date field opens the picker and returns the selected date', (
    tester,
  ) async {
    CalendarDate? chosen;
    final initial = CalendarDate(year: 2026, month: 11, day: 2);
    await loadTestTranslations(
      tester,
      child: Scaffold(
        body: AppDateField(
          label: 'Date',
          value: initial,
          first: CalendarDate(year: 2026, month: 1, day: 1),
          last: CalendarDate(year: 2026, month: 12, day: 31),
          onChanged: (value) {
            chosen = value;
          },
        ),
      ),
    );
    await tester.tap(find.byType(InputDecorator));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);
    await tester.tap(find.text('3').last);
    await tester.tap(find.text('Tamam'));
    await tester.pumpAndSettle();
    expect(chosen, CalendarDate(year: 2026, month: 11, day: 3));
  });
}
