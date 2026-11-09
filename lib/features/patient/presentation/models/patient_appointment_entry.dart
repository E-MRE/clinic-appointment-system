import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/patient/presentation/visitors/patient_preparation_note_visitor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// One of the patient's appointments joined with its catalog records.
/// A record is null when the catalog does not contain it.
final class PatientAppointmentEntry {
  /// Creates an entry from already resolved values.
  const PatientAppointmentEntry({
    required this.appointment,
    required this.service,
    required this.staff,
    required this.branch,
    required this.department,
    required this.isUpcoming,
    required this.canCancel,
  });

  /// The stored appointment.
  final Appointment appointment;

  /// The booked service, if still in the catalog.
  final MedicalService? service;

  /// The assigned staff member, if still in the catalog.
  final Staff? staff;

  /// The hosting branch, if still in the catalog.
  final Branch? branch;

  /// The providing department, if still in the catalog.
  final Department? department;

  /// Whether the appointment is pending or approved and has not started.
  final bool isUpcoming;

  /// Whether the domain allows the patient to cancel it now.
  final bool canCancel;

  /// The localized preparation the service needs, or null when none.
  String? get preparationNote {
    return service?.accept(const PatientPreparationNoteVisitor());
  }
}
