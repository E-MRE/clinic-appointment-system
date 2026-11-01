import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_booking_context.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_rule.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_violation.dart';

/// Checks that one effective staff window encloses the appointment.
final class WithinAvailabilityRule implements AppointmentRule {
  /// Creates the check.
  const WithinAvailabilityRule();

  /// Returns the violation when the check fails.
  @override
  AppointmentViolation? check(
    Appointment candidate,
    AppointmentBookingContext context,
  ) {
    if (!context.availability
        .effectiveWindowsOn(candidate.date, context.branchHours)
        .any((window) => window.range.encloses(candidate.range))) {
      return const AppointmentViolation(
        AppointmentErrorCode.outsideAvailability,
      );
    }
    return null;
  }
}
