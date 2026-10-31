import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/extensions/time_range_label.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:easy_localization/easy_localization.dart';

/// Formats the ranges of one day for the read-only hours section.
extension WorkingHoursRangeLabel on WorkingHours {
  String rangeLabel(Weekday day) {
    final ranges = rangesOn(day);
    if (ranges.isEmpty) return LocaleKeys.institution_closed.tr();
    return ranges.map((range) => range.label).join(' · ');
  }
}
