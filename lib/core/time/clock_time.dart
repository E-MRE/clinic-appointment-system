import 'package:clinic_appointment_system/core/constants/clock_constants.dart';
import 'package:clinic_appointment_system/core/enums/time_error_code.dart';
import 'package:clinic_appointment_system/core/errors/time_exception.dart';
import 'package:equatable/equatable.dart';

/// A minute-precision time of day between 00:00 and 23:59.
final class ClockTime extends Equatable implements Comparable<ClockTime> {
  static int get _clockComponentWidth => 2;

  /// Creates a time from a 24-hour clock hour and minute.
  factory ClockTime({required int hour, required int minute}) {
    if (hour < ClockConstants.midnight ||
        hour >= ClockConstants.hoursPerDay ||
        minute < ClockConstants.midnight ||
        minute >= ClockConstants.minutesPerHour) {
      throw const TimeException(TimeErrorCode.invalidTime);
    }
    return ClockTime._(hour * ClockConstants.minutesPerHour + minute);
  }

  /// Creates a time from the number of minutes since midnight.
  factory ClockTime.fromMinutes(int minutesSinceMidnight) {
    if (minutesSinceMidnight < ClockConstants.midnight ||
        minutesSinceMidnight >= ClockConstants.minutesPerDay) {
      throw const TimeException(TimeErrorCode.invalidTime);
    }
    return ClockTime._(minutesSinceMidnight);
  }

  const ClockTime._(this.minutesSinceMidnight);

  /// The hour component from 0 through 23.
  int get hour => minutesSinceMidnight ~/ ClockConstants.minutesPerHour;

  /// The minute component from 0 through 59.
  int get minute => minutesSinceMidnight % ClockConstants.minutesPerHour;

  /// The number of minutes from midnight.
  final int minutesSinceMidnight;

  /// Whether this time occurs before [other].
  bool isBefore(ClockTime other) => compareTo(other) < 0;

  /// Whether this time occurs after [other].
  bool isAfter(ClockTime other) => compareTo(other) > 0;

  @override
  int compareTo(ClockTime other) =>
      minutesSinceMidnight.compareTo(other.minutesSinceMidnight);

  @override
  List<Object> get props => [minutesSinceMidnight];

  @override
  String toString() {
    final paddedHour = hour.toString().padLeft(_clockComponentWidth, '0');
    final paddedMinute = minute.toString().padLeft(_clockComponentWidth, '0');
    return '$paddedHour:$paddedMinute';
  }
}
