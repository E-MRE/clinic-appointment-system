import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/institution/presentation/services/working_hours_summary_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';

void main() {
  const formatter = WorkingHoursSummaryFormatter();
  final fullDay = TimeRange(
    start: ClockTime(hour: 8, minute: 30),
    end: ClockTime(hour: 18, minute: 0),
  );
  final shortDay = TimeRange(
    start: ClockTime(hour: 9, minute: 0),
    end: ClockTime(hour: 12, minute: 0),
  );
  final afternoon = TimeRange(
    start: ClockTime(hour: 13, minute: 0),
    end: ClockTime(hour: 17, minute: 0),
  );

  testWidgets('groups equal weekdays and lists closed weekend', (tester) async {
    await loadTestTranslations(tester);
    final hours = WorkingHours({
      for (final day in Weekday.values.take(5)) day: [fullDay],
    });
    expect(formatter.format(hours), 'Pzt–Cum 08:30–18:00 · Cmt, Paz kapalı');
  });

  testWidgets('shows Saturday short day and Sunday closed', (tester) async {
    await loadTestTranslations(tester);
    final hours = WorkingHours({
      for (final day in Weekday.values.take(5)) day: [fullDay],
      Weekday.saturday: [shortDay],
    });
    expect(
      formatter.format(hours),
      'Pzt–Cum 08:30–18:00 · Cmt 09:00–12:00 · Paz kapalı',
    );
  });

  testWidgets('formats a split day with comma separated ranges', (
    tester,
  ) async {
    await loadTestTranslations(tester);
    final hours = WorkingHours({
      Weekday.monday: [shortDay, afternoon],
    });
    expect(
      formatter.format(hours),
      'Pzt 09:00–12:00, 13:00–17:00 · Sal, Çar, Per, Cum, Cmt, Paz kapalı',
    );
  });

  testWidgets('labels an all closed week', (tester) async {
    await loadTestTranslations(tester);
    expect(formatter.format(WorkingHours.closed()), 'Tüm günler kapalı');
  });
}
