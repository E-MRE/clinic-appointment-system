import 'package:clinic_appointment_system/core/data/converters/calendar_date_converter.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const converter = CalendarDateConverter();
  test('round trips a calendar date', () {
    final date = CalendarDate(year: 2028, month: 2, day: 29);
    expect(converter.toJson(date), '2028-02-29');
    expect(converter.fromJson('2028-02-29'), date);
  });
  test('rejects malformed and invalid dates', () {
    for (final value in [
      '2026-02-29',
      '2026-13-01',
      '2026-1-01',
      '2026/01/01',
      '2026-01-01x',
      'abcd-01-01',
    ]) {
      expect(() => converter.fromJson(value), throwsFormatException);
    }
  });
}
