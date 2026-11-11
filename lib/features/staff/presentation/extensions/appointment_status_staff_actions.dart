import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';

/// The lifecycle actions staff may consider for an appointment status.
extension AppointmentStatusStaffActions on AppointmentStatus {
  /// Candidate staff actions in display order; the domain decides whether
  /// each one is allowed now.
  List<AppointmentAction> get staffActions {
    return switch (this) {
      AppointmentStatus.pending => const [
        AppointmentAction.reject,
        AppointmentAction.approve,
      ],
      AppointmentStatus.approved => const [
        AppointmentAction.complete,
        AppointmentAction.markNoShow,
        AppointmentAction.cancelByStaff,
      ],
      AppointmentStatus.rejected ||
      AppointmentStatus.cancelledByPatient ||
      AppointmentStatus.cancelledByStaff ||
      AppointmentStatus.completed ||
      AppointmentStatus.noShow => const [],
    };
  }
}
