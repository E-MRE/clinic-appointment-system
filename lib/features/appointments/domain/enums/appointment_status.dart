/// Persisted lifecycle names; behavior is supplied by appointment states.
enum AppointmentStatus {
  /// Requested and awaiting a staff decision.
  pending,

  /// Accepted by the assigned staff member or an admin.
  approved,

  /// Declined before approval.
  rejected,

  /// Cancelled by the appointment's patient before its start.
  cancelledByPatient,

  /// Cancelled by staff after approval.
  cancelledByStaff,

  /// The approved appointment has been fulfilled.
  completed,

  /// The patient did not attend within the tolerance period.
  noShow,
}
