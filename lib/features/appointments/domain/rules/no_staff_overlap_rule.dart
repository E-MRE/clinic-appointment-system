import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_booking_context.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/overlap_rule.dart';

/// Checks that the staff has no overlapping occupied appointment.
final class NoStaffOverlapRule extends OverlapRule {
  /// Creates the check.
  const NoStaffOverlapRule();

  @override
  List<Appointment> appointmentsToScan(AppointmentBookingContext context) =>
      context.staffAppointments;

  @override
  bool sharesOwner(Appointment existing, Appointment candidate) =>
      existing.staffId == candidate.staffId;

  @override
  AppointmentErrorCode get violationCode => AppointmentErrorCode.staffOverlap;
}
