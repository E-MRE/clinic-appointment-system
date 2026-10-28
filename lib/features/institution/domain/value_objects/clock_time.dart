import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';

/// A minute-precision time of day between 00:00 and 23:59.
final class ClockTime implements Comparable<ClockTime> {
  /// Creates a time from a 24-hour clock hour and minute.
  factory ClockTime({required int hour, required int minute}) {
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      throw const InstitutionException(InstitutionErrorCode.invalidTime);
    }
    return ClockTime._(hour * 60 + minute);
  }

  /// Creates a time from the number of minutes since midnight.
  factory ClockTime.fromMinutes(int minutesSinceMidnight) {
    if (minutesSinceMidnight < 0 || minutesSinceMidnight >= 24 * 60) {
      throw const InstitutionException(InstitutionErrorCode.invalidTime);
    }
    return ClockTime._(minutesSinceMidnight);
  }

  const ClockTime._(this.minutesSinceMidnight);

  /// The hour component from 0 through 23.
  int get hour => minutesSinceMidnight ~/ 60;

  /// The minute component from 0 through 59.
  int get minute => minutesSinceMidnight % 60;

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
  bool operator ==(Object other) {
    return other is ClockTime &&
        other.minutesSinceMidnight == minutesSinceMidnight;
  }

  @override
  int get hashCode => minutesSinceMidnight.hashCode;

  @override
  String toString() {
    final paddedHour = hour.toString().padLeft(2, '0');
    final paddedMinute = minute.toString().padLeft(2, '0');
    return '$paddedHour:$paddedMinute';
  }
}
