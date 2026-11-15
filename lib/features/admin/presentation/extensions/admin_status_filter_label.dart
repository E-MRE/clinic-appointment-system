import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_status_filter.dart';

/// Localized label of an administrator status group.
extension AdminStatusFilterLabel on AdminStatusFilter {
  /// The label shared with the appointment status badges.
  String get label {
    return switch (this) {
      AdminStatusFilter.pending => LocaleKeys.appointment_status_pending,
      AdminStatusFilter.approved => LocaleKeys.appointment_status_approved,
      AdminStatusFilter.rejected => LocaleKeys.appointment_status_rejected,
      AdminStatusFilter.completed => LocaleKeys.appointment_status_completed,
      AdminStatusFilter.noShow => LocaleKeys.appointment_status_noShow,
      AdminStatusFilter.cancelled => LocaleKeys.appointment_status_cancelled,
    }.translate();
  }
}
