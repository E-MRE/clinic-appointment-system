/// Identifies failures while resolving accounts or replacing demo data.
enum DemoErrorCode {
  /// The configured doctor profile could not be found.
  doctorAccountMissing,

  /// The configured patient profile could not be found.
  patientAccountMissing,

  /// A configured email belongs to a profile with the wrong role.
  linkedAccountRoleMismatch,

  /// More than one profile matches a configured login email.
  linkedAccountAmbiguous,

  /// A configured account profile is malformed.
  invalidAccountProfile,

  /// A deterministic demo profile id already belongs to a non-demo user.
  recordIdConflict,

  /// A Firestore operation failed or returned an unusable result.
  unavailable,

  /// The generated demo scenario or a stored record was invalid.
  invalidScenario,
}
