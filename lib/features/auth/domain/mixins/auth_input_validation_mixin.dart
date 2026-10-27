import 'package:clinic_appointment_system/core/constants/validation_constants.dart';
import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/app_exception.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_registration.dart';

/// Authentication input rules shared by use cases and form fields.
/// Each check returns the first failing [AuthErrorCode], or null when valid.
mixin AuthInputValidationMixin {
  /// Requires a name without imposing culturally specific name formats.
  AuthErrorCode? fullNameError(String fullName) {
    return fullName.trim().isEmpty ? AuthErrorCode.fullNameRequired : null;
  }

  /// Checks the email format while allowing surrounding whitespace.
  AuthErrorCode? emailError(String email) {
    return ValidationConstants.emailPattern.hasMatch(email.trim())
        ? null
        : AuthErrorCode.invalidEmail;
  }

  /// Requires a password for sign-in and the shared minimum length for sign-up.
  /// Firebase still enforces the configured server-side password policy.
  AuthErrorCode? passwordError(String password, {bool isSignUp = false}) {
    if (password.isEmpty) return AuthErrorCode.missingPassword;
    if (isSignUp &&
        password.length < ValidationConstants.minimumPasswordLength) {
      return AuthErrorCode.passwordTooShort;
    }
    return null;
  }

  /// Checks email first, then password.
  AuthErrorCode? credentialsError(
    AuthCredentials credentials, {
    bool isSignUp = false,
  }) {
    return emailError(credentials.email) ??
        passwordError(credentials.password, isSignUp: isSignUp);
  }

  /// Checks the name first, then the credentials with the sign-up rules.
  AuthErrorCode? registrationError(AuthRegistration registration) {
    return fullNameError(registration.fullName) ??
        credentialsError(registration, isSignUp: true);
  }

  /// Throws [AuthException] with [error] when a check failed.
  void ensureValid(AuthErrorCode? error) {
    if (error != null) throw AuthException(error);
  }
}
