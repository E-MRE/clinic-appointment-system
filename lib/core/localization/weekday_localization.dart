import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:easy_localization/easy_localization.dart';

/// Localized presentation name for a domain weekday.
extension WeekdayLocalization on Weekday {
  /// The abbreviated localized weekday name.
  String get shortLabel => switch (this) {
    Weekday.monday => LocaleKeys.common_weekdaysShort_monday.tr(),
    Weekday.tuesday => LocaleKeys.common_weekdaysShort_tuesday.tr(),
    Weekday.wednesday => LocaleKeys.common_weekdaysShort_wednesday.tr(),
    Weekday.thursday => LocaleKeys.common_weekdaysShort_thursday.tr(),
    Weekday.friday => LocaleKeys.common_weekdaysShort_friday.tr(),
    Weekday.saturday => LocaleKeys.common_weekdaysShort_saturday.tr(),
    Weekday.sunday => LocaleKeys.common_weekdaysShort_sunday.tr(),
  };

  /// The full localized weekday name.
  String get label => switch (this) {
    Weekday.monday => LocaleKeys.common_weekdays_monday.tr(),
    Weekday.tuesday => LocaleKeys.common_weekdays_tuesday.tr(),
    Weekday.wednesday => LocaleKeys.common_weekdays_wednesday.tr(),
    Weekday.thursday => LocaleKeys.common_weekdays_thursday.tr(),
    Weekday.friday => LocaleKeys.common_weekdays_friday.tr(),
    Weekday.saturday => LocaleKeys.common_weekdays_saturday.tr(),
    Weekday.sunday => LocaleKeys.common_weekdays_sunday.tr(),
  };
}
