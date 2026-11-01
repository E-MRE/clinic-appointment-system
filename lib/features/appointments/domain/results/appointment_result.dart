import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';

/// The outcome of an appointment lifecycle operation.
final class AppointmentResult extends Result {
  /// Returns the appointment created by a successful transition.
  const AppointmentResult.success(Appointment this.appointment)
    : errorCode = null,
      super.success();

  /// Returns a lifecycle failure without an appointment or user-facing message.
  const AppointmentResult.error(AppointmentErrorCode this.errorCode)
    : appointment = null,
      super.error();

  /// The updated appointment, or null when the operation failed.
  final Appointment? appointment;

  /// The lifecycle failure, or null when the operation succeeded.
  final AppointmentErrorCode? errorCode;
}
