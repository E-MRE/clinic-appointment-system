/// Fixed values of a 24-hour clock shared by time parsing and editing.
abstract final class ClockConstants {
  /// First hour and minute of a day: 00:00.
  static const int midnight = 0;

  /// Hours in one day.
  static const int hoursPerDay = 24;

  /// Minutes in one hour.
  static const int minutesPerHour = 60;

  /// Minutes in one day.
  static const int minutesPerDay = hoursPerDay * minutesPerHour;

  /// Last hour of a day: 23.
  static const int lastHour = hoursPerDay - 1;

  /// Last minute of an hour: 59.
  static const int lastMinute = minutesPerHour - 1;

  /// Last minute of a day counted from midnight: 23:59.
  static const int lastMinuteOfDay = minutesPerDay - 1;
}
