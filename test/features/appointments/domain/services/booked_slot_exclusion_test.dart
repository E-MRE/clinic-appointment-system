import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/services/booked_slot_exclusion.dart';
import 'package:clinic_appointment_system/features/availability/domain/services/slot_generator.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/booking_fixture.dart';

void main() {
  const f = BookingFixture();
  List<TimeRange> slots(BookedSlotExclusion exclusion) =>
      const SlotGenerator().slotsFor(
        availability: f.availability(),
        date: f.date,
        duration: ServiceDuration(30),
        branchHours: f.hours,
        exclusion: exclusion,
      );
  group('BookedSlotExclusion', () {
    test('an approved appointment removes exactly its slot', () {
      final approved = f.appointment(
        id: 'a',
        status: AppointmentStatus.approved,
      );
      expect(slots(BookedSlotExclusion([approved])), [
        f.range('09:00', '09:30'),
        f.range('09:30', '10:00'),
        f.range('10:30', '11:00'),
        f.range('11:00', '11:30'),
        f.range('11:30', '12:00'),
      ]);
    });
    test('a cancelled appointment removes nothing', () {
      expect(
        slots(
          BookedSlotExclusion([
            f.appointment(status: AppointmentStatus.cancelledByPatient),
          ]),
        ),
        hasLength(6),
      );
    });
    test('an appointment on another date removes nothing', () {
      expect(
        slots(
          BookedSlotExclusion([
            f.appointment(date: CalendarDate(year: 2026, month: 11, day: 2)),
          ]),
        ),
        hasLength(6),
      );
    });
  });
}
