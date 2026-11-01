import 'package:clinic_appointment_system/core/constants/entity_constants.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_booking_context.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_rule.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_violation.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';

/// Scans owner-scoped slots using a shared half-open overlap algorithm.
/// Subclasses supply the projection and violation code.
abstract base class OverlapRule implements AppointmentRule {
  /// Creates an overlap check.
  const OverlapRule();

  /// Provides the owner-scoped occupied slots the subclass checks for conflicts.
  List<BookedSlot> slotsToScan(AppointmentBookingContext context);

  /// Provides the error code for a conflicting appointment.
  AppointmentErrorCode get violationCode;

  @override
  AppointmentViolation? check(
    Appointment candidate,
    AppointmentBookingContext context,
  ) {
    for (final existing in slotsToScan(context)) {
      if (candidate.id != EntityConstants.unsavedId &&
          existing.appointmentId == candidate.id) {
        continue;
      }
      if (existing.date == candidate.date &&
          existing.range.overlaps(candidate.range)) {
        return AppointmentViolation(violationCode, conflict: existing);
      }
    }
    return null;
  }
}
