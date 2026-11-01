import 'package:clinic_appointment_system/core/errors/app_exception.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';

/// A lifecycle failure independent of UI and storage providers.
final class AppointmentException extends AppException {
  /// Creates a failure with a machine-readable cause.
  const AppointmentException(this.code);

  /// The machine-readable cause of this failure.
  final AppointmentErrorCode code;

  /// Describes the failure without user-facing text.
  @override
  String toString() => 'AppointmentException: ${code.name}';
}
