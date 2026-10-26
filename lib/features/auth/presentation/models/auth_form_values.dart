/// Snapshot of form input passed to the concrete authentication page.
/// Passwords remain unchanged and are excluded from string representations.
final class AuthFormValues {
  const AuthFormValues({
    required this.fullName,
    required this.email,
    required this.password,
  });

  final String fullName;
  final String email;
  final String password;

  @override
  String toString() {
    return 'AuthFormValues(fullName: $fullName, email: $email, password: [PROTECTED])';
  }
}
