import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/app_exception.dart';

/// An authentication failure whose code can be mapped to a translation key.
final class AuthException extends AppException {
  const AuthException(this.code, {super.message});

  final AuthErrorCode code;

  @override
  String toString() => 'AuthException: ${code.name}';
}
