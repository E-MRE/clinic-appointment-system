/// Immutable authentication input, validated by use cases with
/// `AuthInputValidationMixin`.
/// Passwords are preserved exactly and excluded from string representations.
base class AuthCredentials {
  const AuthCredentials({required this.email, required this.password});

  final String email;
  final String password;
}
