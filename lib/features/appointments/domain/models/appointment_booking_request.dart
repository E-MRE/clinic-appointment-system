import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// Caller-supplied booking facts; occupied slots are read inside persistence.
final class AppointmentBookingRequest {
  /// Captures the requested appointment and the facts used by booking rules.
  const AppointmentBookingRequest({
    required this.candidate,
    required this.staff,
    required this.service,
    required this.availability,
    required this.branchHours,
  });

  final Appointment candidate;
  final Staff staff;
  final MedicalService service;
  final StaffAvailability availability;
  final WorkingHours branchHours;
}
