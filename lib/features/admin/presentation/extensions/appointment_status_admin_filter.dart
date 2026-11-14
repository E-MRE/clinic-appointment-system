import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_status_filter.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';

/// Maps a lifecycle status to the administrator status group it is counted in.
extension AppointmentStatusAdminFilter on AppointmentStatus {
  /// The group this status belongs to; both cancellations share one group.
  AdminStatusFilter get adminFilter {
    return switch (this) {
      AppointmentStatus.pending => AdminStatusFilter.pending,
      AppointmentStatus.approved => AdminStatusFilter.approved,
      AppointmentStatus.rejected => AdminStatusFilter.rejected,
      AppointmentStatus.completed => AdminStatusFilter.completed,
      AppointmentStatus.noShow => AdminStatusFilter.noShow,
      AppointmentStatus.cancelledByPatient ||
      AppointmentStatus.cancelledByStaff => AdminStatusFilter.cancelled,
    };
  }
}
