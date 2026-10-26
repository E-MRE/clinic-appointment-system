import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';

/// Resolves provider-independent authentication codes at the UI boundary.
extension AuthErrorCodeLocalization on AuthErrorCode {
  String get messageKey {
    return switch (this) {
      AuthErrorCode.invalidEmail => LocaleKeys.auth_errors_invalidEmail,
      AuthErrorCode.missingPassword => LocaleKeys.auth_errors_missingPassword,
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
      AuthErrorCode.unexpected => LocaleKeys.auth_errors_unexpected,
    };
  }
}
