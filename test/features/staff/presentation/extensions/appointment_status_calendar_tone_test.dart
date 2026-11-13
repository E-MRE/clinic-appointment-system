import 'package:clinic_appointment_system/core/theme/appointment_status.dart'
    as palette;
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/appointment_status_calendar_tone.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every status maps to a legend palette; rejected is gray', () {
    const expected = {
      AppointmentStatus.pending: palette.AppointmentStatus.pending,
      AppointmentStatus.approved: palette.AppointmentStatus.approved,
      AppointmentStatus.completed: palette.AppointmentStatus.completed,
      AppointmentStatus.noShow: palette.AppointmentStatus.noShow,
      AppointmentStatus.rejected: palette.AppointmentStatus.cancelled,
      AppointmentStatus.cancelledByPatient: palette.AppointmentStatus.cancelled,
      AppointmentStatus.cancelledByStaff: palette.AppointmentStatus.cancelled,
    };
    for (final status in AppointmentStatus.values) {
      expect(status.calendarTone, expected[status], reason: status.name);
    }
  });
}
