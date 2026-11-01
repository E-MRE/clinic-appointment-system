/// Provider-independent causes of appointment lifecycle failures.
enum AppointmentErrorCode {
  /// The current status does not allow this operation.
  invalidTransition,

  /// The actor's role or identity does not permit this operation.
  notPermitted,

  /// Completion or no-show was attempted before its time boundary.
  tooEarly,

  /// Patient cancellation was attempted at or after the start.
  tooLate,

  /// Stored history is empty or disagrees with the stored status.
  invalidHistory,
}
