import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_booking_context.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/overlap_rule.dart';

/// Checks that the patient has no overlapping occupied appointment.
final class NoPatientOverlapRule extends OverlapRule {
  /// Creates the check.
  const NoPatientOverlapRule();

  @override
  List<Appointment> appointmentsToScan(AppointmentBookingContext context) =>
      context.patientAppointments;

  @override
  bool sharesOwner(Appointment existing, Appointment candidate) =>
      existing.patientId == candidate.patientId;

  @override
  AppointmentErrorCode get violationCode => AppointmentErrorCode.patientOverlap;
}
