import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/no_patient_overlap_rule.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/booking_fixture.dart';

void main() {
  const f = BookingFixture();
  group('NoPatientOverlapRule', () {
    const rule = NoPatientOverlapRule();
    final candidate = f.appointment(range: f.range('09:30', '10:00'));
    test('back-to-back appointments do not conflict', () {
      final adjacent = f.slot(id: 'other', range: f.range('10:00', '10:30'));
      expect(
        rule.check(candidate, f.context(patientSlots: [adjacent])),
        isNull,
      );
    });
    test('a one-minute overlap reports the conflicting appointment', () {
      final overlap = f.slot(id: 'other', range: f.range('09:59', '10:30'));
      expect(
        rule.check(candidate, f.context(patientSlots: [overlap]))?.conflict,
        overlap,
      );
    });
    test('an overlap with another staff member blocks the patient', () {
      final overlap = f.slot(id: 'other', range: f.range('09:59', '10:30'));
      expect(
        rule.check(candidate, f.context(patientSlots: [overlap]))?.code,
        AppointmentErrorCode.patientOverlap,
      );
    });
    test('an appointment on another date does not block', () {
      final existing = f.slot(
        id: 'other',
        date: CalendarDate(year: 2026, month: 11, day: 2),
      );
      expect(
        rule.check(candidate, f.context(patientSlots: [existing])),
        isNull,
      );
    });
    test('the candidate own stored id is ignored', () {
      expect(
        rule.check(
          f.appointment(id: 'same'),
          f.context(patientSlots: [f.slot(id: 'same')]),
        ),
        isNull,
      );
    });
    test('unsaved appointments with the same id can conflict', () {
      expect(
        rule.check(f.appointment(), f.context(patientSlots: [f.slot()]))?.code,
        AppointmentErrorCode.patientOverlap,
      );
    });
    test('only the patient projection is scanned', () {
      final existing = f.slot(id: 'other', range: f.range('09:59', '10:30'));
      expect(rule.check(candidate, f.context(staffSlots: [existing])), isNull);
    });
  });
}
