import 'package:clinic_appointment_system/features/institution/domain/value_objects/clock_time.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/time_range.dart';

/// Holds the editable start and end values for one working-hours range.
final class WorkingHoursRangeDraft {
  /// Creates an editable range from [start] through [end].
  const WorkingHoursRangeDraft({required this.start, required this.end});

  /// The editable start time.
  final ClockTime start;

  /// The editable end time.
  final ClockTime end;

  /// Creates the domain range and lets its constructor validate the interval.
  TimeRange toTimeRange() {
    return TimeRange(start: start, end: end);
  }
}
