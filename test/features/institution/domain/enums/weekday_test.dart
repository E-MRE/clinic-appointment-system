import 'package:clinic_appointment_system/features/institution/domain/enums/weekday.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps a Monday date to Monday', () {
    expect(Weekday.fromDate(DateTime(2026, 10, 26)), Weekday.monday);
  });

  test('maps a Sunday date to Sunday', () {
    expect(Weekday.fromDate(DateTime(2026, 11, 1)), Weekday.sunday);
  });
}
