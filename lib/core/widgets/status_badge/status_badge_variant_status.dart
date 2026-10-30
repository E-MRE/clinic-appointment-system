import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/status_badge/status_badge_variant.dart';

/// Maps a [StatusBadgeVariant] to its appointment status.
extension StatusBadgeVariantStatus on StatusBadgeVariant {
  /// Appointment status represented by this variant, if any.
  AppointmentStatus? get appointmentStatus {
    return switch (this) {
      StatusBadgeVariant.pending => AppointmentStatus.pending,
      StatusBadgeVariant.approved => AppointmentStatus.approved,
      StatusBadgeVariant.rejected => AppointmentStatus.rejected,
      StatusBadgeVariant.completed => AppointmentStatus.completed,
      StatusBadgeVariant.noShow => AppointmentStatus.noShow,
      StatusBadgeVariant.cancelled => AppointmentStatus.cancelled,
      StatusBadgeVariant.neutral || StatusBadgeVariant.info => null,
    };
  }
}
