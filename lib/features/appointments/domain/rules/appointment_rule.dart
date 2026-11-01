import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_booking_context.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_violation.dart';

/// Contract for one independent booking check.
abstract interface class AppointmentRule {
  /// Implementations return a violation, or null when the candidate satisfies the rule.
  AppointmentViolation? check(
    Appointment candidate,
    AppointmentBookingContext context,
  );
}
