import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/features/institution/presentation/extensions/weekday_default_working_ranges.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('uses the default workday range on weekdays and closes weekends', () {
    for (final weekday in [
      Weekday.monday,
      Weekday.tuesday,
      Weekday.wednesday,
      Weekday.thursday,
      Weekday.friday,
    ]) {
      final ranges = weekday.defaultWorkingRanges;

      expect(ranges, hasLength(1), reason: weekday.name);
      expect(ranges.single.start, ClockTime(hour: 9, minute: 0));
      expect(ranges.single.end, ClockTime(hour: 18, minute: 0));
    }

    expect(Weekday.saturday.defaultWorkingRanges, isEmpty);
    expect(Weekday.sunday.defaultWorkingRanges, isEmpty);
  });
}
