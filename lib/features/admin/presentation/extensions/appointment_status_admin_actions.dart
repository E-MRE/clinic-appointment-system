import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';

/// Admin lifecycle actions offered for each appointment status.
extension AppointmentStatusAdminActions on AppointmentStatus {
  /// Candidate actions, later checked against the real domain transition.
  List<AppointmentAction> get adminActions {
    switch (this) {
      case AppointmentStatus.pending:
        return const [AppointmentAction.approve, AppointmentAction.reject];
      case AppointmentStatus.approved:
        return const [AppointmentAction.cancelByStaff];
      case AppointmentStatus.rejected:
      case AppointmentStatus.cancelledByPatient:
      case AppointmentStatus.cancelledByStaff:
      case AppointmentStatus.completed:
      case AppointmentStatus.noShow:
        return const [];
    }
  }
}
