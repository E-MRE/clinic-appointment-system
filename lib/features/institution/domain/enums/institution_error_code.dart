/// Identifies validation and availability failures in the institution domain.
enum InstitutionErrorCode {
  /// A clock time is outside the supported day or minute range.
  invalidTime,

  /// A time range ends at or before it starts.
  closeBeforeOpen,

  /// Two working time ranges overlap on one weekday.
  overlappingRanges,

  /// A clinic, branch or department name is blank.
  nameRequired,

  /// A branch address is blank.
  addressRequired,

  /// A stored institution record does not meet domain requirements.
  invalidRecord,

  /// An institution operation could not complete.
  unavailable,
}
