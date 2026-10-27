/// Named route locations shared by navigation and authentication pages.
/// Registration and password reset sit under sign-in so back pops to it.
abstract final class AppRoutes {
  /// Entry location redirected to the signed-in user's home.
  static const home = '/';

  /// Patient home location.
  static const patientHome = '/patient';

  /// Shared doctor and technician home location.
  static const staffHome = '/staff';

  /// Administrator home location.
  static const adminHome = '/admin';

  /// Debug component catalogue location.
  static const componentPreview = '/debug/components';
  static const signIn = '/sign-in';
  static const signUpSegment = 'register';
  static const passwordResetSegment = 'reset-password';
  static const signUp = '$signIn/$signUpSegment';
  static const passwordReset = '$signIn/$passwordResetSegment';
}
