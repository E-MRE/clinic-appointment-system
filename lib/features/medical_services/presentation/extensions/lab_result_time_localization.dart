import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/lab_result_time.dart';

/// Display labels and summary phrases for laboratory result delivery timeframes.
extension LabResultTimeLocalization on LabResultTime {
  /// Localized label for this result delivery timeframe.
  String get label => labelKey.translate();

  /// Localization key for this result timeframe.
  String get labelKey => switch (this) {
    LabResultTime.sameDay => LocaleKeys.services_labResultTime_sameDay,
    LabResultTime.oneDay => LocaleKeys.services_labResultTime_oneDay,
    LabResultTime.twoDays => LocaleKeys.services_labResultTime_twoDays,
    LabResultTime.threeDays => LocaleKeys.services_labResultTime_threeDays,
    LabResultTime.oneWeek => LocaleKeys.services_labResultTime_oneWeek,
  };

  /// Lowercase or summary phrase for inline service summaries (e.g. `"aynı gün"` vs `"1 gün"`).
  String get resultSummary => switch (this) {
    LabResultTime.sameDay =>
      LocaleKeys.services_summary_lab_resultSameDay.translate(),
    _ => label,
  };
}
