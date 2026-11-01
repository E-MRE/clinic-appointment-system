import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/no_staff_overlap_rule.dart';

import 'package:flutter_test/flutter_test.dart';

import '../support/booking_fixture.dart';

void main() {
  const f = BookingFixture();
  group('NoStaffOverlapRule', () {
    const rule = NoStaffOverlapRule();
    final candidate = f.appointment(range: f.range('09:30', '10:00'));
    test('back-to-back appointments do not conflict', () {
      final adjacent = f.appointment(
        id: 'other',
        range: f.range('10:00', '10:30'),
      );
      expect(
        rule.check(candidate, f.context(staffAppointments: [adjacent])),
        isNull,
      );
    });
    test('a one-minute overlap reports the conflicting appointment', () {
      final overlap = f.appointment(
        id: 'other',
        range: f.range('09:59', '10:30'),
      );
      expect(
        rule
            .check(candidate, f.context(staffAppointments: [overlap]))
            ?.conflict,
        overlap,
      );
    });
    test('an appointment pending blocks', () {
      final existing = f.appointment(
        id: 'other',
        range: f.range('09:59', '10:30'),
        status: AppointmentStatus.pending,
      );
      expect(
        rule.check(candidate, f.context(staffAppointments: [existing]))?.code,
        AppointmentErrorCode.staffOverlap,
      );
    });
    test('an appointment approved blocks', () {
      final existing = f.appointment(
        id: 'other',
        range: f.range('09:59', '10:30'),
        status: AppointmentStatus.approved,
      );
      expect(
        rule.check(candidate, f.context(staffAppointments: [existing]))?.code,
        AppointmentErrorCode.staffOverlap,
      );
    });
    test('an appointment completed blocks', () {
      final existing = f.appointment(
        id: 'other',
        range: f.range('09:59', '10:30'),
        status: AppointmentStatus.completed,
      );
      expect(
        rule.check(candidate, f.context(staffAppointments: [existing]))?.code,
        AppointmentErrorCode.staffOverlap,
      );
    });
    test('an appointment no-show blocks', () {
      final existing = f.appointment(
        id: 'other',
        range: f.range('09:59', '10:30'),
        status: AppointmentStatus.noShow,
      );
      expect(
        rule.check(candidate, f.context(staffAppointments: [existing]))?.code,
        AppointmentErrorCode.staffOverlap,
      );
    });
    test('an appointment rejected does not block', () {
      final existing = f.appointment(
        id: 'other',
        range: f.range('09:59', '10:30'),
        status: AppointmentStatus.rejected,
      );
      expect(
        rule.check(candidate, f.context(staffAppointments: [existing])),
        isNull,
      );
    });
    test('an appointment cancelled by the patient does not block', () {
      final existing = f.appointment(
        id: 'other',
        range: f.range('09:59', '10:30'),
        status: AppointmentStatus.cancelledByPatient,
      );
      expect(
        rule.check(candidate, f.context(staffAppointments: [existing])),
        isNull,
      );
    });
    test('an appointment cancelled by staff does not block', () {
      final existing = f.appointment(
        id: 'other',
        range: f.range('09:59', '10:30'),
        status: AppointmentStatus.cancelledByStaff,
      );
      expect(
        rule.check(candidate, f.context(staffAppointments: [existing])),
        isNull,
      );
    });
    test('an appointment on another date does not block', () {
      final existing = f.appointment(
        id: 'other',
        date: CalendarDate(year: 2026, month: 11, day: 2),
      );
      expect(
        rule.check(candidate, f.context(staffAppointments: [existing])),
        isNull,
      );
    });
    test('the candidate own stored id is ignored', () {
      expect(
        rule.check(
          f.appointment(id: 'same'),
          f.context(staffAppointments: [f.appointment(id: 'same')]),
        ),
        isNull,
      );
    });
    test('unsaved appointments with the same id can conflict', () {
      expect(
        rule
            .check(
              f.appointment(),
              f.context(staffAppointments: [f.appointment()]),
            )
            ?.code,
        AppointmentErrorCode.staffOverlap,
      );
    });
    test('a different staff does not block', () {
      final existing = f.appointment(
        id: 'other',
        staffId: 'different',
        range: f.range('09:59', '10:30'),
      );
      expect(
        rule.check(candidate, f.context(staffAppointments: [existing])),
        isNull,
      );
    });
  });
}
