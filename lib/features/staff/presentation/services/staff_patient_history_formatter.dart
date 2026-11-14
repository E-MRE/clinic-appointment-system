import 'package:clinic_appointment_system/core/extensions/date_time_formatting.dart';
import 'package:clinic_appointment_system/core/localization/localization_extension.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_patient_history.dart';
import 'package:clinic_appointment_system/generated/localization/lang/locale_keys.g.dart';

/// Formats localized labels for a patient's completed visit history.
final class StaffPatientHistoryFormatter {
  /// Creates the formatter.
  const StaffPatientHistoryFormatter();

  /// Localized completed visit count label for [history].
  String completedLabel(StaffPatientHistory history) {
    return LocaleKeys.staffRequests_history_completed.translate(
      args: ['${history.completedCount}'],
    );
  }

  /// Localized latest visit label for [history], or null when no visit exists.
  String? lastVisitLabel(StaffPatientHistory history) {
    final latestVisit = history.latestVisitDate;
    if (latestVisit == null) return null;
    return LocaleKeys.staffRequests_history_lastVisit.translate(
      args: [latestVisit.dayMonthLabel()],
    );
  }
}
