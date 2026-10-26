/// Identifies profile failures independently of the storage provider.
enum UserErrorCode {
  /// No profile exists for the authenticated user.
  profileMissing,

  /// The stored profile does not contain valid required fields.
  invalidProfile,

  /// The profile could not be read or written.
  unavailable,
}
