import 'package:clinic_appointment_system/core/errors/app_exception.dart';

/// Converts authentication errors without coupling callers to a provider.
abstract interface class AuthExceptionMapper {
  /// Returns an application exception while preserving relevant error details.
  AppException map(Object error);
}
