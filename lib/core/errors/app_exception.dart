import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';

/// Base exception for application-specific errors.
class AppException implements Exception {
  const AppException({this.message = ''});

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// An authentication failure whose code can be mapped to a translation key.
final class AuthException extends AppException {
  const AuthException(this.code, {super.message});

  final AuthErrorCode code;

  @override
  String toString() => 'AuthException: ${code.name}';
}

/// An unexpected failure, including a provider response missing required data.
final class UnexpectedException extends AppException {
  const UnexpectedException({super.message});
}
