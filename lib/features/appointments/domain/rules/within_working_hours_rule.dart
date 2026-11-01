import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_booking_context.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_rule.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_violation.dart';

/// Checks that one branch range encloses the appointment.
final class WithinWorkingHoursRule implements AppointmentRule {
  /// Creates the check.
  const WithinWorkingHoursRule();

  /// Returns the violation when the check fails.
  @override
  AppointmentViolation? check(
    Appointment candidate,
    AppointmentBookingContext context,
  ) {
    if (!context.branchHours
        .rangesOn(candidate.date.weekday)
        .any((range) => range.encloses(candidate.range))) {
      return const AppointmentViolation(
        AppointmentErrorCode.outsideWorkingHours,
      );
    }
    return null;
  }
}
