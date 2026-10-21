import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/app_exception.dart';
import 'package:clinic_appointment_system/features/auth/domain/mappers/auth_exception_mapper.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Translates provider failures into shared application exception types.
final class FirebaseAuthExceptionMapper implements AuthExceptionMapper {
  const FirebaseAuthExceptionMapper();

  /// Preserves the exception message and any existing application exception.
  @override
  AppException map(Object error) {
    if (error is AppException) return error;
    if (error is! FirebaseAuthException) {
      return AuthException(AuthErrorCode.unexpected, message: error.toString());
    }
    final code = switch (error.code) {
      'invalid-email' => AuthErrorCode.invalidEmail,
      'weak-password' => AuthErrorCode.weakPassword,
      'email-already-in-use' => AuthErrorCode.emailAlreadyInUse,
      'invalid-credential' ||
      'wrong-password' ||
      'user-not-found' ||
      'INVALID_LOGIN_CREDENTIALS' => AuthErrorCode.invalidCredentials,
      'user-disabled' => AuthErrorCode.userDisabled,
      'too-many-requests' => AuthErrorCode.tooManyRequests,
      'network-request-failed' => AuthErrorCode.networkRequestFailed,
      'operation-not-allowed' => AuthErrorCode.operationNotAllowed,
      _ => AuthErrorCode.unexpected,
    };
    final message = error.message ?? error.code;
    return AuthException(code, message: message);
  }
}
