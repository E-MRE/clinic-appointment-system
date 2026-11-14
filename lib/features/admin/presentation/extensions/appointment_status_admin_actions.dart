import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';

/// Admin lifecycle actions offered for each appointment status.
extension AppointmentStatusAdminActions on AppointmentStatus {
  /// Candidate actions, later checked against the real domain transition.
  List<AppointmentAction> get adminActions {
    return switch (this) {
      AppointmentStatus.pending => const [
        AppointmentAction.approve,
        AppointmentAction.reject,
      ],
      AppointmentStatus.approved => const [AppointmentAction.cancelByStaff],
      AppointmentStatus.rejected ||
      AppointmentStatus.cancelledByPatient ||
      AppointmentStatus.cancelledByStaff ||
      AppointmentStatus.completed ||
      AppointmentStatus.noShow => const [],
    };
  }
}
