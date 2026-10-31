import 'package:clinic_appointment_system/core/constants/availability_constants.dart';
import 'package:clinic_appointment_system/core/constants/clock_constants.dart';
import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/availability/presentation/models/timeline_segment.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';

/// Normalizes branch opening hours to a shared weekly timeline axis.
final class AvailabilityTimeline {
  /// Finds the earliest opening and latest closing, or midnight when all closed.
  factory AvailabilityTimeline(WorkingHours branchHours) {
    final ranges = [
      for (final day in Weekday.values) ...branchHours.rangesOn(day),
    ];
    if (ranges.isEmpty) {
      final midnight = ClockTime.fromMinutes(ClockConstants.midnight);
      return AvailabilityTimeline._(axisStart: midnight, axisEnd: midnight);
    }
    final starts = ranges.map((range) => range.start).toList()..sort();
    final ends = ranges.map((range) => range.end).toList()..sort();
    return AvailabilityTimeline._(axisStart: starts.first, axisEnd: ends.last);
  }

  const AvailabilityTimeline._({
    required this.axisStart,
    required this.axisEnd,
  });

  /// Earliest opening across the week.
  final ClockTime axisStart;

  /// Latest closing across the week.
  final ClockTime axisEnd;

  /// Whether no branch range contributes a visible axis.
  bool get isEmpty => axisStart == axisEnd;

  /// Localized-clock axis endpoints for captions and guidance.
  String get axisLabel => '$axisStart–$axisEnd';

  /// Named lower bound of the normalized axis.
  static const double _minimumFraction = 0;

  /// Named upper bound of the normalized axis.
  static const double _maximumFraction = 1;

  /// Clamps [time] to its normalized position, returning zero for a closed week.
  double fractionOf(ClockTime time) {
    if (isEmpty) return _minimumFraction;
    final offset = time.minutesSinceMidnight - axisStart.minutesSinceMidnight;
    final span = axisEnd.minutesSinceMidnight - axisStart.minutesSinceMidnight;
    return (offset / span).clamp(_minimumFraction, _maximumFraction);
  }

  /// Two-hour ticks starting at the first whole hour at or after opening.
  /// For 08:30–18:00, the ticks are 09:00, 11:00, 13:00, 15:00 and 17:00.
  List<ClockTime> get ticks {
    if (isEmpty) return const [];
    final first =
        (axisStart.minutesSinceMidnight / ClockConstants.minutesPerHour)
            .ceil() *
        ClockConstants.minutesPerHour;
    return List.unmodifiable([
      for (
        int minute = first;
        minute <= axisEnd.minutesSinceMidnight;
        minute += AvailabilityConstants.timelineTickStepMinutes
      )
        ClockTime.fromMinutes(minute),
    ]);
  }

  /// Clips [range] to the visible axis and returns its horizontal fractions.
  TimelineSegment segmentOf(TimeRange range) {
    final start = fractionOf(range.start);
    return TimelineSegment(start: start, width: fractionOf(range.end) - start);
  }
}
