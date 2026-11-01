import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_booking_context.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/overlap_rule.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';

/// Checks that the patient has no overlapping occupied appointment.
final class NoPatientOverlapRule extends OverlapRule {
  /// Creates the check.
  const NoPatientOverlapRule();

  @override
  List<BookedSlot> slotsToScan(AppointmentBookingContext context) =>
      context.patientSlots;

  @override
  AppointmentErrorCode get violationCode => AppointmentErrorCode.patientOverlap;
}
