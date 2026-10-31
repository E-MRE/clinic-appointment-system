import 'package:clinic_appointment_system/core/constants/clock_constants.dart';
import 'package:clinic_appointment_system/core/constants/working_hours_constants.dart';
import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
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

  /// Replaces the initial draft with the schedule selected for editing.
  void initialize(WorkingHours? hours) {
    emit(WorkingHoursEditorState.fromWorkingHours(hours));
  }

  /// Toggles [weekday], retaining saved ranges or adding the default range.
  void toggleDay(Weekday weekday) {
    final current = state.day(weekday);
    final isOpen = !current.isOpen;
    final ranges = current.ranges.isEmpty && isOpen
        ? [WorkingHoursRangeDraft.workday()]
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
    WorkingHoursEditorState nextState = state;
    for (final weekday in Weekday.values.where(
      (day) => day.index <= Weekday.friday.index,
    )) {
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
    final rangesByDay = <Weekday, List<TimeRange>>{};
    for (final weekday in Weekday.values) {
      final day = state.day(weekday);
      if (day.isOpen) {
        rangesByDay[weekday] = day.ranges
            .map((range) => range.toTimeRange())
            .toList();
      } else {
        rangesByDay[weekday] = <TimeRange>[];
      }
    }
    return WorkingHours(rangesByDay);
  }

  bool _hasRange(WorkingHoursDayDraft day, int index) =>
      index >= 0 && index < day.ranges.length;

  WorkingHoursRangeDraft _nextRange(WorkingHoursDayDraft day) {
    if (day.ranges.isEmpty) return WorkingHoursRangeDraft.workday();
    int latestEnd = ClockConstants.midnight;
    for (final range in day.ranges) {
      if (range.end.minutesSinceMidnight > latestEnd) {
        latestEnd = range.end.minutesSinceMidnight;
      }
    }
    final start = latestEnd < ClockConstants.lastMinuteOfDay
        ? latestEnd
        : ClockConstants.midnight;
    final proposedEnd = start + WorkingHoursConstants.rangeStepMinutes;
    final end = proposedEnd <= ClockConstants.lastMinuteOfDay
        ? proposedEnd
        : ClockConstants.lastMinuteOfDay;
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
}
