/// Identifies a shared date or time validation failure.
enum TimeErrorCode {
  /// The clock time is outside the valid day.
  invalidTime,

  /// The end of a range does not follow its start.
  endBeforeStart,

  /// The calendar date does not exist.
  invalidDate,
}
