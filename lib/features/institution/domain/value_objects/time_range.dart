import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/clock_time.dart';

/// A non-empty half-open interval of a day, including its start and excluding
/// its end.
final class TimeRange {
  /// Creates a range whose [end] occurs after [start].
  factory TimeRange({required ClockTime start, required ClockTime end}) {
    if (!end.isAfter(start)) {
      throw const InstitutionException(InstitutionErrorCode.closeBeforeOpen);
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

  @override
  bool operator ==(Object other) {
    return other is TimeRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);
}
