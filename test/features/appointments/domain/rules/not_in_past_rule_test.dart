import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/not_in_past_rule.dart';

import 'package:flutter_test/flutter_test.dart';

import '../support/booking_fixture.dart';

void main() {
  const f = BookingFixture();
  group('NotInPastRule', () {
    const rule = NotInPastRule();
    test('a start one minute before now fails', () {
      expect(
        rule
            .check(f.appointment(), f.context(now: f.at('2026-11-01', '10:01')))
            ?.code,
        AppointmentErrorCode.inPast,
      );
    });
    test('a start exactly at now passes', () {
      final candidate = f.appointment();
      expect(rule.check(candidate, f.context(now: candidate.startsAt)), isNull);
    });
  });
}
