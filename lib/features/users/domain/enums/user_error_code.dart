/// Identifies profile failures independently of the storage provider.
enum UserErrorCode {
  /// No profile exists for the authenticated user.
  profileMissing,

  /// The stored profile does not contain valid required fields.
  invalidProfile,

  /// The profile could not be read or written.
  unavailable,

  /// A staff full name is required.
  fullNameRequired,

  /// The staff email does not match the accepted email format.
  invalidEmail,

  /// A staff branch identifier is required.
  branchRequired,

  /// A staff department identifier is required.
  departmentRequired,

  /// A doctor's specialty is required.
  specialtyRequired,

  /// A medical service identifier is assigned more than once.
  duplicateService,

  /// The number of assigned medical services exceeds the allowed limit.
  tooManyServices,

  /// An assigned service is unknown or not eligible for this staff member.
  ineligibleService,

  /// Profile creation failed and the new sign-in account could not be deleted.
  orphanAccount,
}
