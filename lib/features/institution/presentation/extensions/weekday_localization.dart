import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/weekday.dart';
import 'package:easy_localization/easy_localization.dart';

/// Localized presentation name for a domain weekday.
extension WeekdayLocalization on Weekday {
  String get shortLabel => switch (this) {
    Weekday.monday => LocaleKeys.institution_weekdaysShort_monday.tr(),
    Weekday.tuesday => LocaleKeys.institution_weekdaysShort_tuesday.tr(),
    Weekday.wednesday => LocaleKeys.institution_weekdaysShort_wednesday.tr(),
    Weekday.thursday => LocaleKeys.institution_weekdaysShort_thursday.tr(),
    Weekday.friday => LocaleKeys.institution_weekdaysShort_friday.tr(),
    Weekday.saturday => LocaleKeys.institution_weekdaysShort_saturday.tr(),
    Weekday.sunday => LocaleKeys.institution_weekdaysShort_sunday.tr(),
  };

  String get label => switch (this) {
    Weekday.monday => LocaleKeys.institution_weekdays_monday.tr(),
    Weekday.tuesday => LocaleKeys.institution_weekdays_tuesday.tr(),
    Weekday.wednesday => LocaleKeys.institution_weekdays_wednesday.tr(),
    Weekday.thursday => LocaleKeys.institution_weekdays_thursday.tr(),
    Weekday.friday => LocaleKeys.institution_weekdays_friday.tr(),
    Weekday.saturday => LocaleKeys.institution_weekdays_saturday.tr(),
    Weekday.sunday => LocaleKeys.institution_weekdays_sunday.tr(),
  };
}
