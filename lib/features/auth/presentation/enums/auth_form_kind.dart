/// Authentication screen variants; their labels, dimensions and layout
/// decisions come from `AuthFormConfig`.
enum AuthFormKind {
  /// Sign-in screen for every role.
  signIn,

  /// Patient self-registration screen.
  signUp,

  /// Password reset request screen.
  passwordReset,
}
