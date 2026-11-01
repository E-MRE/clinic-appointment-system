import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_booking_context.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_rule.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_violation.dart';

/// Checks staff identity and service eligibility.
final class StaffProvidesServiceRule implements AppointmentRule {
  /// Creates the check.
  const StaffProvidesServiceRule();

  /// Returns the violation when the check fails.
  @override
  AppointmentViolation? check(
    Appointment candidate,
    AppointmentBookingContext context,
  ) {
    if (candidate.staffId != context.staff.id ||
        candidate.serviceId != context.service.id ||
        !context.staff.serviceIds.contains(context.service.id) ||
        !context.staff.canProvide(context.service)) {
      return const AppointmentViolation(
        AppointmentErrorCode.serviceNotProvided,
      );
    }
    return null;
  }
}
