import 'package:clinic_appointment_system/features/appointments/domain/actors/appointment_actor.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';

/// Lifecycle permissions for an admin.
final class AdminAppointmentActor extends AppointmentActor {
  /// Creates an immutable admin actor.
  const AdminAppointmentActor({required super.id});

  /// The role recorded in the audit trail.
  @override
  UserRole get role => UserRole.admin;

  /// Whether this actor represents the appointment patient.
  @override
  bool mayActAsPatient(String patientId) => false;

  /// Whether this actor may act for the assigned staff member.
  @override
  bool mayActAsStaff(String staffId) => true;

  /// Whether this actor may mark the assigned appointment as a no-show.
  @override
  bool mayMarkNoShow(String staffId) => false;
}
