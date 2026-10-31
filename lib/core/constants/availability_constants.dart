/// Storage limits shared by availability validation and persistence rules.
abstract final class AvailabilityConstants {
  /// Maximum recurring windows on a single weekday: 12.
  static const int maxWindowsPerDay = 12;

  /// Maximum extra dated windows per staff schedule: 60.
  static const int maxOneOffWindows = 60;
}
