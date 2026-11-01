import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_booking_context.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_rule.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_violation.dart';

/// Checks that the appointment has not started before now.
final class NotInPastRule implements AppointmentRule {
  /// Creates the check.
  const NotInPastRule();

  /// Returns the violation when the check fails.
  @override
  AppointmentViolation? check(
    Appointment candidate,
    AppointmentBookingContext context,
  ) {
    if (candidate.startsAt.isBefore(context.now)) {
      return const AppointmentViolation(AppointmentErrorCode.inPast);
    }
    return null;
  }
}
