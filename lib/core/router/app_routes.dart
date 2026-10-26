/// Named route locations shared by navigation and authentication pages.
/// Registration and password reset sit under sign-in so back pops to it.
abstract final class AppRoutes {
  static const home = '/';

  /// Debug component catalogue location.
  static const componentPreview = '/debug/components';
  static const signIn = '/sign-in';
  static const signUpSegment = 'register';
  static const passwordResetSegment = 'reset-password';
  static const signUp = '$signIn/$signUpSegment';
  static const passwordReset = '$signIn/$passwordResetSegment';
}
