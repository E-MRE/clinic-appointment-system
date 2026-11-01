/// Visual meaning of a saved or drafted availability range.
enum AvailabilityTimelineBarVariant {
  /// A persisted range inside current branch hours.
  saved,

  /// A persisted range outside current branch hours.
  flagged,

  /// The unsaved range currently being edited.
  pending,
}
