/// Limits and presentation intervals shared by availability.
abstract final class AvailabilityConstants {
  /// Timeline tick interval in minutes: 120.
  static const int timelineTickStepMinutes = 120;

  /// Furthest selectable one-off date, in days from today: 365.
  static const int oneOffHorizonDays = 365;

  /// Maximum recurring windows on a single weekday: 12.
  static const int maxWindowsPerDay = 12;

  /// Maximum extra dated windows per staff schedule: 60.
  static const int maxOneOffWindows = 60;
}
