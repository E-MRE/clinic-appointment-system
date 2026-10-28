import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/weekday.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/time_range.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/institution/presentation/extensions/weekday_localization.dart';
import 'package:easy_localization/easy_localization.dart';

/// Presents adjacent days with equal hours as one localized range.
extension WorkingHoursSummary on WorkingHours {
  String get localizedSummary {
    final sections = <String>[];
    final closed = <Weekday>[];
    const days = Weekday.values;
    var index = 0;
    while (index < days.length) {
      final day = days[index];
      if (isClosedOn(day)) {
        closed.add(day);
        index++;
        continue;
      }
      final ranges = rangesOn(day);
      var end = index;
      while (end + 1 < days.length &&
          _sameRanges(ranges, rangesOn(days[end + 1]))) {
        end++;
      }
      final daysLabel = end == index
          ? day.shortLabel
          : '${day.shortLabel}–${days[end].shortLabel}';
      sections.add('$daysLabel ${_formatRanges(ranges)}');
      index = end + 1;
    }
    if (closed.length == days.length) {
      return LocaleKeys.institution_allDaysClosed.tr();
    }
    if (closed.isNotEmpty) {
      sections.add(
        '${closed.map((day) => day.shortLabel).join(', ')} ${LocaleKeys.institution_closed.tr().toLowerCase()}',
      );
    }
    return sections.join(' · ');
  }

  bool _sameRanges(List<TimeRange> first, List<TimeRange> second) {
    if (first.length != second.length) return false;
    for (var index = 0; index < first.length; index++) {
      if (first[index] != second[index]) return false;
    }
    return true;
  }

  String _formatRanges(List<TimeRange> ranges) =>
      ranges.map((range) => '${range.start}–${range.end}').join(', ');
}
