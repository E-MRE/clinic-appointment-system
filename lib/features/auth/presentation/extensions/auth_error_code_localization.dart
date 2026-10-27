import 'package:clinic_appointment_system/core/constants/validation_constants.dart';
import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';

/// Resolves provider-independent authentication codes at the UI boundary.
extension AuthErrorCodeLocalization on AuthErrorCode {
  /// The localized message, with the arguments its key needs.
  String get message => messageKey.translate(namedArgs: _namedArgs);

  Map<String, String>? get _namedArgs {
    return this == AuthErrorCode.passwordTooShort
        ? TranslationArgs.forMinimumLength(
            ValidationConstants.minimumPasswordLength,
          )
        : null;
  }

  String get messageKey {
    return switch (this) {
      AuthErrorCode.invalidEmail => LocaleKeys.auth_errors_invalidEmail,
      AuthErrorCode.missingPassword => LocaleKeys.auth_errors_missingPassword,
      AuthErrorCode.passwordTooShort => LocaleKeys.validation_passwordTooShort,
      AuthErrorCode.fullNameRequired => LocaleKeys.validation_fullNameRequired,
      AuthErrorCode.weakPassword => LocaleKeys.auth_errors_weakPassword,
      AuthErrorCode.invalidCredentials =>
        LocaleKeys.auth_errors_invalidCredentials,
      AuthErrorCode.emailAlreadyInUse =>
        LocaleKeys.auth_errors_emailAlreadyInUse,
      AuthErrorCode.userDisabled => LocaleKeys.auth_errors_userDisabled,
      AuthErrorCode.tooManyRequests => LocaleKeys.auth_errors_tooManyRequests,
      AuthErrorCode.networkRequestFailed =>
        LocaleKeys.auth_errors_networkRequestFailed,
      AuthErrorCode.operationNotAllowed =>
        LocaleKeys.auth_errors_operationNotAllowed,
      AuthErrorCode.profileUpdateFailed =>
        LocaleKeys.auth_errors_profileUpdateFailed,
      AuthErrorCode.profileCreationFailed =>
        LocaleKeys.auth_errors_profileCreationFailed,
      AuthErrorCode.unexpected => LocaleKeys.auth_errors_unexpected,
    };
  }
}
