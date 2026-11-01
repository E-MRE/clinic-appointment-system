import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// All data needed to check a booking, supplied by the caller.
final class AppointmentBookingContext {
  /// Copies appointment lists so later caller mutations cannot change checks.
  AppointmentBookingContext({
    required this.staff,
    required this.service,
    required this.availability,
    required this.branchHours,
    required List<Appointment> staffAppointments,
    required List<Appointment> patientAppointments,
    required this.now,
  }) : staffAppointments = List<Appointment>.unmodifiable(staffAppointments),
       patientAppointments = List<Appointment>.unmodifiable(
         patientAppointments,
       );

  /// The assigned staff member.
  final Staff staff;

  /// The selected service.
  final MedicalService service;

  /// The staff member's availability.
  final StaffAvailability availability;

  /// The branch's current working hours.
  final WorkingHours branchHours;

  /// Existing appointments of the staff member.
  final List<Appointment> staffAppointments;

  /// Existing appointments of the patient.
  final List<Appointment> patientAppointments;

  /// The instant at which the booking is checked.
  final DateTime now;
}
