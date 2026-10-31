import 'package:clinic_appointment_system/core/enums/time_error_code.dart';
import 'package:clinic_appointment_system/core/errors/time_exception.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:equatable/equatable.dart';

/// A non-empty half-open interval of a day, including its start and excluding
/// its end.
final class TimeRange extends Equatable {
  /// Creates a range whose [end] occurs after [start].
  factory TimeRange({required ClockTime start, required ClockTime end}) {
    if (!end.isAfter(start)) {
      throw const TimeException(TimeErrorCode.endBeforeStart);
    }
    return TimeRange._(start: start, end: end);
  }

  const TimeRange._({required this.start, required this.end});

  /// The inclusive beginning of the range.
  final ClockTime start;

  /// The exclusive end of the range.
  final ClockTime end;

  /// Whether this range shares any time with [other].
  bool overlaps(TimeRange other) {
    return start.isBefore(other.end) && other.start.isBefore(end);
  }

  /// Whether [time] falls within this range.
  bool contains(ClockTime time) => !time.isBefore(start) && time.isBefore(end);

  /// Whether [other] lies entirely within this range.
  bool encloses(TimeRange other) =>
      !other.start.isBefore(start) && !other.end.isAfter(end);

  /// The length of this range in minutes.
  int get durationMinutes =>
      end.minutesSinceMidnight - start.minutesSinceMidnight;

  @override
  List<Object> get props => [start, end];
}
