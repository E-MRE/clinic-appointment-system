import 'package:clinic_appointment_system/core/localization/localization_extension.dart';
import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_request_sort.dart';
import 'package:clinic_appointment_system/generated/localization/lang/locale_keys.g.dart';

/// Localized label mapping for [StaffRequestSort].
extension StaffRequestSortLabel on StaffRequestSort {
  /// The localized label for the sort toggle.
  String get label {
    return switch (this) {
      StaffRequestSort.byDate =>
        LocaleKeys.staffRequests_sort_byDate.translate(),
      StaffRequestSort.byRequestTime =>
        LocaleKeys.staffRequests_sort_byRequestTime.translate(),
    };
  }
}
