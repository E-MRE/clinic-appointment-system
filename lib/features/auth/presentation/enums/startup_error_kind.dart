/// Presentation variant of a session-startup failure.
enum StartupErrorKind {
  /// The device has no connection.
  offline,

  /// The session could not be started for another reason.
  failure,

  /// The signed-in account has no profile document; retrying cannot help.
  profileMissing,

  /// The stored profile is incomplete or malformed; retrying cannot help.
  invalidProfile,

  /// The profile could not be loaded, usually because of the connection.
  profileUnavailable,
}
