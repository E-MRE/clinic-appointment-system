import 'package:clinic_appointment_system/features/appointments/domain/actors/admin_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/patient_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/staff_appointment_actor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';

/// An actor's identity snapshot; subclasses provide their lifecycle permissions.
abstract base class AppointmentActor {
  /// Creates an actor identity for a concrete role.
  const AppointmentActor({required this.id});

  /// Captures a profile's identity and selects behavior by its declared role.
  factory AppointmentActor.fromUser(User user) {
    return switch (user.role) {
      UserRole.patient => PatientAppointmentActor(id: user.id),
      UserRole.doctor => StaffAppointmentActor.doctor(id: user.id),
      UserRole.technician => StaffAppointmentActor.technician(id: user.id),
      UserRole.admin => AdminAppointmentActor(id: user.id),
    };
  }

  /// The acting user's identifier.
  final String id;

  /// Subclasses must provide the role recorded in the audit trail.
  UserRole get role;

  /// Subclasses must decide whether they represent this appointment's patient.
  bool mayActAsPatient(String patientId);

  /// Subclasses must decide whether they may act for the assigned staff member.
  bool mayActAsStaff(String staffId);

  /// Subclasses must allow no-show marking only for the assigned staff member.
  bool mayMarkNoShow(String staffId);
}
