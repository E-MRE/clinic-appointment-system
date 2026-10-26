/// The authenticated identity, independent of the role profile introduced later.
/// Contains no credentials, Firebase user object or mutable authentication state.
final class AuthSession {
  const AuthSession({
    required this.userId,
    required this.email,
    required this.isEmailVerified,
  });

  final String userId;
  final String email;
  final bool isEmailVerified;
}
