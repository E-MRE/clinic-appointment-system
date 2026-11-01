import 'package:clinic_appointment_system/core/constants/entity_constants.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_booking_context.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_rule.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_violation.dart';

/// Scans appointments for an occupied overlap belonging to the same owner.
abstract base class OverlapRule implements AppointmentRule {
  /// Creates an overlap check.
  const OverlapRule();

  /// Provides the appointments the subclass checks for conflicts.
  List<Appointment> appointmentsToScan(AppointmentBookingContext context);

  /// Identifies whether the appointments share the owner being checked.
  bool sharesOwner(Appointment existing, Appointment candidate);

  /// Provides the error code for a conflicting appointment.
  AppointmentErrorCode get violationCode;

  @override
  AppointmentViolation? check(
    Appointment candidate,
    AppointmentBookingContext context,
  ) {
    for (final existing in appointmentsToScan(context)) {
      if (candidate.id != EntityConstants.unsavedId &&
          existing.id == candidate.id) {
        continue;
      }
      if (sharesOwner(existing, candidate) &&
          existing.date == candidate.date &&
          existing.occupiesSlot &&
          existing.range.overlaps(candidate.range)) {
        return AppointmentViolation(violationCode, conflict: existing);
      }
    }
    return null;
  }
}
