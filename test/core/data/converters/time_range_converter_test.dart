import 'package:clinic_appointment_system/core/data/converters/time_range_converter.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const converter = TimeRangeConverter();
  test('round trips the exact stored shape', () {
    final range = TimeRange(
      start: ClockTime(hour: 9, minute: 0),
      end: ClockTime(hour: 12, minute: 0),
    );
    final json = {'start': '09:00', 'end': '12:00'};
    expect(converter.toJson(range), json);
    expect(converter.fromJson(json), range);
  });
  test('rejects missing, extra, wrong type and invalid time fields', () {
    for (final json in <Map<String, dynamic>>[
      {'start': '09:00'},
      {'start': '09:00', 'end': '12:00', 'extra': 1},
      {'start': 9, 'end': '12:00'},
      {'start': 'bad', 'end': '12:00'},
    ]) {
      expect(() => converter.fromJson(json), throwsFormatException);
    }
  });
}
