import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/patient/presentation/enums/day_period.dart';

/// Localized name of a [DayPeriod].
extension DayPeriodLocalization on DayPeriod {
  /// The period name (`Sabah`, `Öğleden sonra`, `Akşam`).
  String get label {
    return switch (this) {
      DayPeriod.morning => LocaleKeys.patient_book_periods_morning,
      DayPeriod.afternoon => LocaleKeys.patient_book_periods_afternoon,
      DayPeriod.evening => LocaleKeys.patient_book_periods_evening,
    }.translate();
  }
}
