import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_validator.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/not_in_past_rule.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/booking_fixture.dart';

void main() {
  const f = BookingFixture();
  group('AppointmentValidator', () {
    test('a valid candidate has no violations', () {
      const validator = AppointmentValidator.standard();
      expect(validator.validate(f.lifecycle.request(), f.context()), isEmpty);
    });
    test('returns every violation in rule order', () {
      const validator = AppointmentValidator.standard();
      final candidate = f.lifecycle.request();
      final violations = validator.validate(
        candidate,
        f.context(
          now: f.at('2026-11-01', '11:00'),
          staff: f.doctor(serviceIds: []),
          staffAppointments: [f.appointment(id: 'other')],
        ),
      );
      expect(violations.map((v) => v.code), [
        AppointmentErrorCode.inPast,
        AppointmentErrorCode.serviceNotProvided,
        AppointmentErrorCode.staffOverlap,
      ]);
    });
    test('context copies and protects both appointment lists', () {
      final staff = <Appointment>[f.appointment()];
      final patient = <Appointment>[f.appointment()];
      final context = f.context(
        staffAppointments: staff,
        patientAppointments: patient,
      );
      staff.clear();
      patient.clear();
      expect(context.staffAppointments, hasLength(1));
      expect(context.patientAppointments, hasLength(1));
      expect(() => context.staffAppointments.clear(), throwsUnsupportedError);
      expect(() => context.patientAppointments.clear(), throwsUnsupportedError);
    });
    test('custom rule list controls validation', () {
      const validator = AppointmentValidator([NotInPastRule()]);
      expect(
        validator.validate(
          f.appointment(),
          f.context(staff: f.doctor(serviceIds: [])),
        ),
        isEmpty,
      );
    });
  });
}
