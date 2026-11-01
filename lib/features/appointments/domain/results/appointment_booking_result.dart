import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_violation.dart';

/// Booking success, validation violations, or a persistence failure.
final class AppointmentBookingResult extends Result {
  /// Carries the saved appointment including its generated identifier.
  const AppointmentBookingResult.success(Appointment this.appointment)
    : violations = const [],
      errorCode = null,
      super.success();

  /// Copies all validation failures; no appointment was written.
  AppointmentBookingResult.violations(List<AppointmentViolation> violations)
    : appointment = null,
      violations = List.unmodifiable(violations),
      errorCode = null,
      super.error();

  /// Carries a provider-independent persistence failure.
  const AppointmentBookingResult.error(AppointmentErrorCode this.errorCode)
    : appointment = null,
      violations = const [],
      super.error();

  /// The saved appointment on success.
  final Appointment? appointment;

  /// All booking violations, empty for success or persistence failures.
  final List<AppointmentViolation> violations;

  /// The storage failure, absent for success and validation rejections.
  final AppointmentErrorCode? errorCode;
}
