import 'package:clinic_appointment_system/features/institution/domain/enums/weekday.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/clock_time.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/time_range.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/working_hours_editor_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/working_hours_day_draft.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/working_hours_range_draft.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Edits branch working-hours drafts and delegates interval rules to the domain.
final class WorkingHoursEditorCubit extends Cubit<WorkingHoursEditorState> {
  /// Creates a new-branch draft or initializes from [initialHours] for editing.
  WorkingHoursEditorCubit({WorkingHours? initialHours})
    : super(WorkingHoursEditorState.fromWorkingHours(initialHours));

  /// Toggles [weekday], retaining saved ranges or adding the default range.
  void toggleDay(Weekday weekday) {
    final current = state.day(weekday);
    final isOpen = !current.isOpen;
    final ranges = current.ranges.isEmpty && isOpen
        ? _defaultRanges
        : current.ranges;
    _replaceDay(weekday, isOpen: isOpen, ranges: ranges);
  }

  /// Adds a range to [weekday], defaulting to the next hour when times are absent.
  void addRange(Weekday weekday, [ClockTime? start, ClockTime? end]) {
    final current = state.day(weekday);
    final ranges = [
      ...current.ranges,
      start != null && end != null
          ? WorkingHoursRangeDraft(start: start, end: end)
          : _nextRange(current),
    ];
    _replaceDay(weekday, isOpen: true, ranges: ranges);
  }

  /// Replaces a range on [weekday] with the supplied [start] and [end].
  void updateRange(Weekday weekday, int index, ClockTime start, ClockTime end) {
    final current = state.day(weekday);
    if (!_hasRange(current, index)) return;
    final ranges = List<WorkingHoursRangeDraft>.of(current.ranges);
    ranges[index] = WorkingHoursRangeDraft(start: start, end: end);
    _replaceDay(weekday, isOpen: current.isOpen, ranges: ranges);
  }

  /// Removes the range at [index] from [weekday].
  void removeRange(Weekday weekday, int index) {
    final current = state.day(weekday);
    if (!_hasRange(current, index)) return;
    final ranges = List<WorkingHoursRangeDraft>.of(current.ranges)
      ..removeAt(index);
    _replaceDay(
      weekday,
      isOpen: current.isOpen && ranges.isNotEmpty,
      ranges: ranges,
    );
  }

  /// Copies [from]'s open state and ranges to Monday through Friday.
  void copyToWeekdays(Weekday from) {
    final source = state.day(from);
    var nextState = state;
    for (final weekday in Weekday.values.take(5)) {
      nextState = nextState.replacing(
        WorkingHoursDayDraft(
          weekday: weekday,
          isOpen: source.isOpen,
          ranges: source.ranges,
        ),
      );
    }
    emit(nextState);
  }

  /// Builds validated working hours, or returns null while any day has errors.
  WorkingHours? build() {
    if (state.hasErrors) return null;
    return WorkingHours({
      for (final weekday in Weekday.values)
        weekday: state.day(weekday).isOpen
            ? state
                  .day(weekday)
                  .ranges
                  .map((range) => range.toTimeRange())
                  .toList()
            : <TimeRange>[],
    });
  }

  bool _hasRange(WorkingHoursDayDraft day, int index) =>
      index >= 0 && index < day.ranges.length;

  WorkingHoursRangeDraft _nextRange(WorkingHoursDayDraft day) {
    if (day.ranges.isEmpty) return _defaultRanges.single;
    var latestEnd = 0;
    for (final range in day.ranges) {
      if (range.end.minutesSinceMidnight > latestEnd) {
        latestEnd = range.end.minutesSinceMidnight;
      }
    }
    final start = latestEnd < 23 * 60 + 59 ? latestEnd : 0;
    final proposedEnd = start + 60;
    final end = proposedEnd <= 23 * 60 + 59 ? proposedEnd : 23 * 60 + 59;
    return WorkingHoursRangeDraft(
      start: ClockTime.fromMinutes(start),
      end: ClockTime.fromMinutes(end),
    );
  }

  void _replaceDay(
    Weekday weekday, {
    required bool isOpen,
    required List<WorkingHoursRangeDraft> ranges,
  }) {
    emit(
      state.replacing(
        WorkingHoursDayDraft(weekday: weekday, isOpen: isOpen, ranges: ranges),
      ),
    );
  }

  List<WorkingHoursRangeDraft> get _defaultRanges => [
    WorkingHoursRangeDraft(
      start: ClockTime(hour: 9, minute: 0),
      end: ClockTime(hour: 18, minute: 0),
    ),
  ];
}
