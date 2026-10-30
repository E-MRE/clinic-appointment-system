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
    int index = 0;
    while (index < Weekday.values.length) {
      final day = Weekday.values[index];
      if (isClosedOn(day)) {
        closed.add(day);
        index++;
        continue;
      }
      final ranges = rangesOn(day);
      final end = _lastMatchingDay(index, ranges);
      sections.add('${_dayLabel(index, end)} ${_formatRanges(ranges)}');
      index = end + 1;
    }
    if (closed.length == Weekday.values.length) {
      return LocaleKeys.institution_allDaysClosed.tr();
    }
    if (closed.isNotEmpty) sections.add(_closedLabel(closed));
    return sections.join(' · ');
  }

  int _lastMatchingDay(int first, List<TimeRange> ranges) {
    int last = first;
    while (last + 1 < Weekday.values.length &&
        _sameRanges(ranges, rangesOn(Weekday.values[last + 1]))) {
      last++;
    }
    return last;
  }

  String _dayLabel(int first, int last) {
    final start = Weekday.values[first].shortLabel;
    if (first == last) return start;
    return '$start–${Weekday.values[last].shortLabel}';
  }

  String _closedLabel(List<Weekday> days) {
    final labels = days.map((day) => day.shortLabel).join(', ');
    return '$labels ${LocaleKeys.institution_closed.tr().toLowerCase()}';
  }

  bool _sameRanges(List<TimeRange> first, List<TimeRange> second) {
    if (first.length != second.length) return false;
    for (int index = 0; index < first.length; index++) {
      if (first[index] != second[index]) return false;
    }
    return true;
  }

  String _formatRanges(List<TimeRange> ranges) =>
      ranges.map((range) => '${range.start}–${range.end}').join(', ');
}
