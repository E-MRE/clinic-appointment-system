import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/widgets/status_badge/status_badge_variant.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';

/// Badge appearance and localized label of a lifecycle status.
extension AppointmentStatusPresentation on AppointmentStatus {
  /// The shared badge variant showing this status.
  StatusBadgeVariant get badgeVariant {
    return switch (this) {
      AppointmentStatus.pending => StatusBadgeVariant.pending,
      AppointmentStatus.approved => StatusBadgeVariant.approved,
      AppointmentStatus.rejected => StatusBadgeVariant.rejected,
      AppointmentStatus.cancelledByPatient ||
      AppointmentStatus.cancelledByStaff => StatusBadgeVariant.cancelled,
      AppointmentStatus.completed => StatusBadgeVariant.completed,
      AppointmentStatus.noShow => StatusBadgeVariant.noShow,
    };
  }

  /// The localized status label.
  String get label {
    return switch (this) {
      AppointmentStatus.pending => LocaleKeys.appointment_status_pending,
      AppointmentStatus.approved => LocaleKeys.appointment_status_approved,
      AppointmentStatus.rejected => LocaleKeys.appointment_status_rejected,
      AppointmentStatus.cancelledByPatient ||
      AppointmentStatus.cancelledByStaff =>
        LocaleKeys.appointment_status_cancelled,
      AppointmentStatus.completed => LocaleKeys.appointment_status_completed,
      AppointmentStatus.noShow => LocaleKeys.appointment_status_noShow,
    }.translate();
  }
}
