import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_booking_context.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/overlap_rule.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';

/// Checks that the staff has no overlapping occupied appointment.
final class NoStaffOverlapRule extends OverlapRule {
  /// Creates the check.
  const NoStaffOverlapRule();

  @override
  List<BookedSlot> slotsToScan(AppointmentBookingContext context) =>
      context.staffSlots;

  @override
  AppointmentErrorCode get violationCode => AppointmentErrorCode.staffOverlap;
}
