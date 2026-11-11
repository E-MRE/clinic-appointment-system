import 'package:clinic_appointment_system/core/theme/appointment_status.dart'
    as palette;
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';

/// Status palette of an appointment block on the staff calendar.
extension AppointmentStatusCalendarTone on AppointmentStatus {
  /// The palette this status's calendar block uses. Rejected appointments
  /// share the gray cancelled palette, matching the calendar legend.
  palette.AppointmentStatus get calendarTone {
    return switch (this) {
      AppointmentStatus.pending => palette.AppointmentStatus.pending,
      AppointmentStatus.approved => palette.AppointmentStatus.approved,
      AppointmentStatus.completed => palette.AppointmentStatus.completed,
      AppointmentStatus.noShow => palette.AppointmentStatus.noShow,
      AppointmentStatus.rejected ||
      AppointmentStatus.cancelledByPatient ||
      AppointmentStatus.cancelledByStaff => palette.AppointmentStatus.cancelled,
    };
  }
}
