/// Status groups the administrator filters and counts appointments by.
///
/// [cancelled] groups patient and staff cancellations into one choice.
enum AdminStatusFilter {
  /// Requested and awaiting a decision.
  pending,

  /// Accepted and scheduled.
  approved,

  /// Declined before approval.
  rejected,

  /// Fulfilled.
  completed,

  /// Marked as not attended.
  noShow,

  /// Cancelled by the patient or by staff.
  cancelled,
}
