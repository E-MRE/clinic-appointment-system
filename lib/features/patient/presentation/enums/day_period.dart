/// The part of the day an availability window starts in.
enum DayPeriod {
  /// Starts before 12:00.
  morning,

  /// Starts from 12:00 and before 17:00.
  afternoon,

  /// Starts from 17:00.
  evening,
}
