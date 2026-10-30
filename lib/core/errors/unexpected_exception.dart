import 'package:clinic_appointment_system/core/errors/app_exception.dart';

/// An unexpected failure, including a provider response missing required data.
final class UnexpectedException extends AppException {
  const UnexpectedException({super.message});
}
