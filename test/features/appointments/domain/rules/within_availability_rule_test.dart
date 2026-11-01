import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/within_availability_rule.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/one_off_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/weekly_window.dart';

import 'package:flutter_test/flutter_test.dart';

import '../support/booking_fixture.dart';

void main() {
  const f = BookingFixture();
  group('WithinAvailabilityRule', () {
    const rule = WithinAvailabilityRule();
    test('inside a weekly window passes', () {
      expect(rule.check(f.appointment(), f.context()), isNull);
    });
    test('inside a one-off window passes', () {
      final availability = f.availability(
        oneOff: [OneOffWindow(date: f.date, range: f.range('13:00', '14:00'))],
      );
      expect(
        rule.check(
          f.appointment(range: f.range('13:00', '13:30')),
          f.context(availability: availability),
        ),
        isNull,
      );
    });
    test('spanning a gap between windows fails', () {
      final availability = f.availability(
        weekly: [
          WeeklyWindow(
            weekday: f.date.weekday,
            range: f.range('09:00', '10:00'),
          ),
          WeeklyWindow(
            weekday: f.date.weekday,
            range: f.range('10:30', '11:30'),
          ),
        ],
      );
      expect(
        rule
            .check(
              f.appointment(range: f.range('09:50', '10:40')),
              f.context(availability: availability),
            )
            ?.code,
        AppointmentErrorCode.outsideAvailability,
      );
    });
    test('a window outside current branch hours does not count', () {
      final stale = f.availability(
        weekly: [
          WeeklyWindow(
            weekday: f.date.weekday,
            range: f.range('11:30', '12:30'),
          ),
        ],
      );
      expect(
        rule
            .check(
              f.appointment(range: f.range('11:30', '11:50')),
              f.context(availability: stale),
            )
            ?.code,
        AppointmentErrorCode.outsideAvailability,
      );
    });
  });
}
