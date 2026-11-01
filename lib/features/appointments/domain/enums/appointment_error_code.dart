/// Provider-independent causes of appointment lifecycle and booking failures.
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

  /// The appointment starts before the current instant.
  inPast,

  /// The appointment falls outside branch working hours.
  outsideWorkingHours,

  /// The appointment falls outside effective staff availability.
  outsideAvailability,

  /// The assigned staff member cannot provide the service.
  serviceNotProvided,

  /// An occupied appointment overlaps for the staff member.
  staffOverlap,

  /// An occupied appointment overlaps for the patient.
  patientOverlap,
}
