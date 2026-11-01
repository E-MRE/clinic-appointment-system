import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
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
        expect(fixture.restore(entry.key).occupiesSlot, entry.value);
      });
    }
  });
}
