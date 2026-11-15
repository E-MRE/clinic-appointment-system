import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/extensions/time_range_label.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/localization/weekday_localization.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:easy_localization/easy_localization.dart';

/// Groups and localizes a branch's weekly working hours for display.
final class WorkingHoursSummaryFormatter {
  /// Creates a formatter for weekly working hours.
  const WorkingHoursSummaryFormatter();

  /// Formats open-day ranges and closed days into one localized summary.
  String format(WorkingHours hours) {
    final sections = <String>[];
    final closed = <Weekday>[];
    int index = _firstIndex;
    while (index < Weekday.values.length) {
      final day = Weekday.values[index];
      if (hours.isClosedOn(day)) {
        closed.add(day);
        index++;
        continue;
      }
      final ranges = hours.rangesOn(day);
      final end = _lastMatchingDay(hours, index, ranges);
      sections.add('${_dayLabel(index, end)} ${_formatRanges(ranges)}');
      index = end + _nextIndex;
    }
    if (closed.length == Weekday.values.length) {
      return LocaleKeys.institution_allDaysClosed.tr();
    }
    if (closed.isNotEmpty) sections.add(_closedLabel(closed));
    return sections.join(' · ');
  }

  /// value = 0
  int get _firstIndex => 0;

  /// value = 1
  int get _nextIndex => 1;

  int _lastMatchingDay(WorkingHours hours, int first, List<TimeRange> ranges) {
    int last = first;
    while (last + _nextIndex < Weekday.values.length &&
        _sameRanges(
          ranges,
          hours.rangesOn(Weekday.values[last + _nextIndex]),
        )) {
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
    for (int index = _firstIndex; index < first.length; index++) {
      if (first[index] != second[index]) return false;
    }
    return true;
  }

  String _formatRanges(List<TimeRange> ranges) {
    return ranges.map((range) => range.label).join(', ');
  }
}
