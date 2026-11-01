import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// All data needed to check a booking, supplied by the caller.
final class AppointmentBookingContext {
  /// Copies slot lists so later caller mutations cannot change checks.
  AppointmentBookingContext({
    required this.staff,
    required this.service,
    required this.availability,
    required this.branchHours,
    required List<BookedSlot> staffSlots,
    required List<BookedSlot> patientSlots,
    required this.now,
  }) : staffSlots = List<BookedSlot>.unmodifiable(staffSlots),
       patientSlots = List<BookedSlot>.unmodifiable(patientSlots);

  /// The assigned staff member.
  final Staff staff;

  /// The selected service.
  final MedicalService service;

  /// The staff member's availability.
  final StaffAvailability availability;

  /// The branch's current working hours.
  final WorkingHours branchHours;

  /// Occupied slots of the staff member.
  final List<BookedSlot> staffSlots;

  /// Occupied slots of the patient.
  final List<BookedSlot> patientSlots;

  /// The instant at which the booking is checked.
  final DateTime now;
}
