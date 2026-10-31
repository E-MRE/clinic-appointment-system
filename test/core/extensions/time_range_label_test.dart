import 'package:clinic_appointment_system/core/extensions/time_range_label.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formats a range with an en dash', () {
    final range = TimeRange(
      start: ClockTime(hour: 9, minute: 0),
      end: ClockTime(hour: 12, minute: 0),
    );
    expect(range.label, '09:00–12:00');
  });
}
