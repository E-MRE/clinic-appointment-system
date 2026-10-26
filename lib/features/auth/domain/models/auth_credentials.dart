/// Immutable authentication input. Validation belongs to the form flow.
/// Passwords are preserved exactly and excluded from string representations.
base class AuthCredentials {
  const AuthCredentials({required this.email, required this.password});

  final String email;
  final String password;
}
