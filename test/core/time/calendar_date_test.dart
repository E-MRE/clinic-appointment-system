import 'package:clinic_appointment_system/core/enums/time_error_code.dart';
import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/errors/time_exception.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('validates real calendar dates', () {
    expect(CalendarDate(year: 2028, month: 2, day: 29).day, 29);
    for (final parts in [
      [2026, 2, 29],
      [2026, 0, 1],
      [2026, 13, 1],
      [2026, 1, 0],
      [2026, 1, 32],
    ]) {
      expect(
        () => CalendarDate(year: parts[0], month: parts[1], day: parts[2]),
        throwsA(
          isA<TimeException>().having(
            (error) => error.code,
            'code',
            TimeErrorCode.invalidDate,
          ),
        ),
      );
    }
  });
  test('drops time, exposes weekday, compares and pads', () {
    final date = CalendarDate.fromDateTime(DateTime(2026, 11, 2, 23, 59, 59));
    final later = CalendarDate(year: 2026, month: 11, day: 3);
    expect(date, CalendarDate(year: 2026, month: 11, day: 2));
    expect(date.weekday, Weekday.monday);
    expect(date.isBefore(later), isTrue);
    expect(later.isAfter(date), isTrue);
    expect(date.compareTo(later), lessThan(0));
    expect(date.compareTo(date), 0);
    expect(CalendarDate(year: 7, month: 1, day: 2).toString(), '0007-01-02');
  });
}
