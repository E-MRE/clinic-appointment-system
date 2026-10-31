import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_today.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fixed_clock.dart';

void main() {
  group('ClockToday', () {
    test('discards time without advancing the date at 23:59:59', () {
      final clock = FixedClock(DateTime(2026, 11, 1, 23, 59, 59));
      expect(clock.today, CalendarDate(year: 2026, month: 11, day: 1));
    });
    test('uses the calendar components provided by a UTC clock', () {
      final clock = FixedClock(DateTime.utc(2026, 11, 2));
      expect(clock.today, CalendarDate(year: 2026, month: 11, day: 2));
    });
  });
}
