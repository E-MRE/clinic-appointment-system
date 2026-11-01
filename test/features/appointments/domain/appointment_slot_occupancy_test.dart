import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/appointment_fixture.dart';

void main() {
  const fixture = AppointmentFixture();
  group('slot occupancy', () {
    const expectations = {
      AppointmentStatus.pending: true,
      AppointmentStatus.approved: true,
      AppointmentStatus.rejected: false,
      AppointmentStatus.cancelledByPatient: false,
      AppointmentStatus.cancelledByStaff: false,
      AppointmentStatus.completed: true,
      AppointmentStatus.noShow: true,
    };
    for (final entry in expectations.entries) {
      test('${entry.key.name} occupies slot: ${entry.value}', () {
        final appointment = fixture.restore(entry.key);
        expect(appointment.occupiesSlot, entry.value);
        if (entry.value) {
          expect(
            appointment.bookedSlot,
            BookedSlot(
              appointmentId: 'appointment',
              date: fixture.date,
              range: fixture.range,
            ),
          );
        } else {
          expect(appointment.bookedSlot, isNull);
        }
      });
    }
  });
}
