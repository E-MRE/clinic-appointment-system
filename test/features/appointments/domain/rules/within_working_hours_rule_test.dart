import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/within_working_hours_rule.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';

import 'package:flutter_test/flutter_test.dart';

import '../support/booking_fixture.dart';

void main() {
  const f = BookingFixture();
  group('WithinWorkingHoursRule', () {
    const rule = WithinWorkingHoursRule();
    test('a range spanning lunch fails', () {
      expect(
        rule
            .check(f.appointment(range: f.range('11:30', '12:30')), f.context())
            ?.code,
        AppointmentErrorCode.outsideWorkingHours,
      );
    });
    test('a range starting at opening passes', () {
      expect(
        rule.check(
          f.appointment(range: f.range('08:30', '09:00')),
          f.context(),
        ),
        isNull,
      );
    });
    test('a range ending at closing passes', () {
      expect(
        rule.check(
          f.appointment(range: f.range('17:30', '18:00')),
          f.context(),
        ),
        isNull,
      );
    });
    test('a closed day fails', () {
      expect(
        rule
            .check(f.appointment(), f.context(hours: WorkingHours.closed()))
            ?.code,
        AppointmentErrorCode.outsideWorkingHours,
      );
    });
  });
}
