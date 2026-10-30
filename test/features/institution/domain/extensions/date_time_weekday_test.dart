import 'package:clinic_appointment_system/features/institution/domain/enums/weekday.dart';
import 'package:clinic_appointment_system/features/institution/domain/extensions/date_time_weekday.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps a Monday date to Monday', () {
    expect(DateTime(2026, 10, 26).toWeekday(), Weekday.monday);
  });

  test('maps a Sunday date to Sunday', () {
    expect(DateTime(2026, 11, 1).toWeekday(), Weekday.sunday);
  });
}
