import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/states/appointment_state.dart';

/// Resolves persisted enum names to polymorphic lifecycle behavior.
extension AppointmentStatusState on AppointmentStatus {
  /// The stateless lifecycle policy for this status.
  AppointmentState get state => switch (this) {
    AppointmentStatus.pending => const PendingAppointmentState(),
    AppointmentStatus.approved => const ApprovedAppointmentState(),
    AppointmentStatus.rejected => const RejectedAppointmentState(),
    AppointmentStatus.cancelledByPatient =>
      const CancelledByPatientAppointmentState(),
    AppointmentStatus.cancelledByStaff =>
      const CancelledByStaffAppointmentState(),
    AppointmentStatus.completed => const CompletedAppointmentState(),
    AppointmentStatus.noShow => const NoShowAppointmentState(),
  };
}
