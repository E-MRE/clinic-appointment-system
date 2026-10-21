import 'package:clinic_appointment_system/core/constants/validation_constants.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';

/// Reusable form validation for authentication cubits with localized messages.
mixin AuthValidationMixin {
  /// Checks the email format while allowing surrounding whitespace.
  Result validateEmail(String email) =>
      ValidationConstants.emailPattern.hasMatch(email.trim())
      ? const Result.success()
      : Result.error(message: LocaleKeys.validation_invalidEmail.translate());

  /// Requires a password for sign-in and the shared minimum length for sign-up.
  /// Firebase still enforces the configured server-side password policy.
  Result validatePassword(String password, {bool isSignUp = false}) {
    if (password.isEmpty) {
      return Result.error(
        message: LocaleKeys.validation_passwordRequired.translate(),
      );
    }
    if (isSignUp &&
        password.length < ValidationConstants.minimumPasswordLength) {
      return Result.error(
        message: LocaleKeys.validation_passwordTooShort.translate(
          namedArgs: {
            'minimumLength': '${ValidationConstants.minimumPasswordLength}',
          },
        ),
      );
    }
    return const Result.success();
  }

  /// Checks email first, then password, and returns the first localized failure.
  Result validateCredentials(
    AuthCredentials credentials, {
    bool isSignUp = false,
  }) {
    final emailResult = validateEmail(credentials.email);
    if (emailResult.isNotSuccess) return emailResult;
    return validatePassword(credentials.password, isSignUp: isSignUp);
  }
}
