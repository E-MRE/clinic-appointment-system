/// Provider-independent availability failures.
enum AvailabilityErrorCode {
  /// A window intersects another window on a shared day.
  overlappingWindow,

  /// A window does not fit a single branch working range.
  outsideBranchHours,

  /// The branch has no working hours on the window's weekday.
  branchClosed,

  /// A dated window precedes today.
  pastDate,

  /// Adding a window would exceed its kind's storage limit.
  tooManyWindows,

  /// The requested window does not exist in the schedule.
  windowNotFound,

  /// Stored availability cannot be read as a valid record.
  invalidRecord,

  /// The availability provider cannot complete the operation.
  unavailable,
}
