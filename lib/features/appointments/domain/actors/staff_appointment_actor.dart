import 'package:clinic_appointment_system/features/appointments/domain/actors/appointment_actor.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';

/// Lifecycle permissions shared by doctors and technicians.
final class StaffAppointmentActor extends AppointmentActor {
  /// Creates an immutable doctor actor.
  const StaffAppointmentActor.doctor({required super.id})
    : role = UserRole.doctor;

  /// Creates an immutable technician actor.
  const StaffAppointmentActor.technician({required super.id})
    : role = UserRole.technician;

  /// The original staff role recorded in the audit trail.
  @override
  final UserRole role;

  /// Whether this actor represents the appointment patient.
  @override
  bool mayActAsPatient(String patientId) => false;

  /// Whether this actor may act for the assigned staff member.
  @override
  bool mayActAsStaff(String staffId) => id == staffId;

  /// Whether this actor may mark the assigned appointment as a no-show.
  @override
  bool mayMarkNoShow(String staffId) => id == staffId;
}
