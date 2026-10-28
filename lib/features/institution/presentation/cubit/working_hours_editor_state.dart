import 'package:clinic_appointment_system/features/institution/domain/enums/weekday.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/clock_time.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/working_hours_day_draft.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/working_hours_range_draft.dart';

/// Immutable snapshot of each weekday's working-hours editor draft.
final class WorkingHoursEditorState {
  /// Creates an editor state containing a draft for every weekday.
  WorkingHoursEditorState(Map<Weekday, WorkingHoursDayDraft> days)
    : days = Map<Weekday, WorkingHoursDayDraft>.unmodifiable({
        for (final weekday in Weekday.values)
          weekday:
              days[weekday] ??
              WorkingHoursDayDraft(
                weekday: weekday,
                isOpen: false,
                ranges: const [],
              ),
      });

  /// Creates a new-branch default or copies an existing domain schedule.
  factory WorkingHoursEditorState.fromWorkingHours(WorkingHours? hours) {
    final days = <Weekday, WorkingHoursDayDraft>{};
    for (final weekday in Weekday.values) {
      final ranges = hours == null
          ? _defaultRangesFor(weekday)
          : hours
                .rangesOn(weekday)
                .map(
                  (range) => WorkingHoursRangeDraft(
                    start: range.start,
                    end: range.end,
                  ),
                )
                .toList();
      days[weekday] = WorkingHoursDayDraft(
        weekday: weekday,
        isOpen: ranges.isNotEmpty,
        ranges: ranges,
      );
    }
    return WorkingHoursEditorState(days);
  }

  /// The immutable weekday drafts in Monday-to-Sunday order.
  final Map<Weekday, WorkingHoursDayDraft> days;

  /// Whether any open weekday currently has a domain validation error.
  bool get hasErrors => days.values.any((day) => day.error != null);

  /// Returns the draft for [weekday].
  WorkingHoursDayDraft day(Weekday weekday) => days[weekday]!;

  /// Returns a new state with [dayDraft] replacing its weekday draft.
  WorkingHoursEditorState replacing(WorkingHoursDayDraft dayDraft) {
    return WorkingHoursEditorState({...days, dayDraft.weekday: dayDraft});
  }

  static List<WorkingHoursRangeDraft> _defaultRangesFor(Weekday weekday) {
    if (weekday.index > Weekday.friday.index) return const [];
    return [
      WorkingHoursRangeDraft(
        start: ClockTime(hour: 9, minute: 0),
        end: ClockTime(hour: 18, minute: 0),
      ),
    ];
  }
}
