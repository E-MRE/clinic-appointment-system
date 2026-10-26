import 'package:clinic_appointment_system/core/constants/validation_constants.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_registration.dart';

/// Reusable form validation for authentication cubits with localized messages.
mixin AuthValidationMixin {
  /// Requires a name without imposing culturally specific name formats.
  Result validateFullName(String fullName) {
    return fullName.trim().isEmpty
        ? Result.error(
            message: LocaleKeys.validation_fullNameRequired.translate(),
          )
        : const Result.success();
  }

  /// Validates that the password and confirmation match.
  Result validatePasswordConfirmation(String password, String? confirmation) {
    if (password != confirmation) {
      return Result.error(
        message: LocaleKeys.validation_passwordMismatch.translate(),
      );
    }
    return const Result.success();
  }

  /// Checks the name and credentials before creating an account.
  Result validateRegistration(AuthRegistration registration) {
    final nameResult = validateFullName(registration.fullName);
    if (nameResult.isNotSuccess) return nameResult;
    final credentialsResult = validateCredentials(registration, isSignUp: true);
    if (credentialsResult.isNotSuccess) return credentialsResult;
    return const Result.success();
  }

  /// Checks the email format while allowing surrounding whitespace.
  Result validateEmail(String email) {
    return ValidationConstants.emailPattern.hasMatch(email.trim())
        ? const Result.success()
        : Result.error(message: LocaleKeys.validation_invalidEmail.translate());
  }

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
          namedArgs: TranslationArgs.forMinimumLength(
            ValidationConstants.minimumPasswordLength,
          ),
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
