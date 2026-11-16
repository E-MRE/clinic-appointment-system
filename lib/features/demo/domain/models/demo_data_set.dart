import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:equatable/equatable.dart';

/// Immutable, complete domain records for one repeatable demo scenario.
final class DemoDataSet extends Equatable {
  /// Copies each collection so the generated scenario cannot be changed later.
  factory DemoDataSet({
    required CalendarDate referenceDate,
    required Clinic clinic,
    required Iterable<Branch> branches,
    required Iterable<Department> departments,
    required Iterable<MedicalService> services,
    required Iterable<Staff> staff,
    required Iterable<Patient> patients,
    required Iterable<StaffAvailability> availabilities,
    required Iterable<Appointment> appointments,
  }) {
    final branchRecords = List<Branch>.unmodifiable(branches);
    final departmentRecords = List<Department>.unmodifiable(departments);
    final serviceRecords = List<MedicalService>.unmodifiable(services);
    final staffRecords = List<Staff>.unmodifiable(staff);
    final patientRecords = List<Patient>.unmodifiable(patients);
    final availabilityRecords = List<StaffAvailability>.unmodifiable(
      availabilities,
    );
    final appointmentRecords = List<Appointment>.unmodifiable(appointments);
    final recordIds = <String>{
      clinic.id,
      for (final branch in branchRecords) branch.id,
      for (final department in departmentRecords) department.id,
      for (final service in serviceRecords) service.id,
      for (final member in staffRecords) member.id,
      for (final patient in patientRecords) patient.id,
      for (final availability in availabilityRecords) availability.staffId,
      for (final appointment in appointmentRecords) appointment.id,
    };
    return DemoDataSet._(
      referenceDate: referenceDate,
      clinic: clinic,
      branches: branchRecords,
      departments: departmentRecords,
      services: serviceRecords,
      staff: staffRecords,
      patients: patientRecords,
      availabilities: availabilityRecords,
      appointments: appointmentRecords,
      demoRecordIds: Set<String>.unmodifiable(recordIds),
    );
  }

  const DemoDataSet._({
    required this.referenceDate,
    required this.clinic,
    required this.branches,
    required this.departments,
    required this.services,
    required this.staff,
    required this.patients,
    required this.availabilities,
    required this.appointments,
    required this.demoRecordIds,
  });

  /// The clock date from which appointment dates are offset.
  final CalendarDate referenceDate;

  /// The clinic owning the demo branches.
  final Clinic clinic;

  /// The two clinic branches and their working hours.
  final List<Branch> branches;

  /// The departments assigned to the branches.
  final List<Department> departments;

  /// The examination, laboratory and radiology services in the scenario.
  final List<MedicalService> services;

  /// The linked doctor and profile-only staff members.
  final List<Staff> staff;

  /// The linked patient and profile-only patients.
  final List<Patient> patients;

  /// Weekly availability documents for every staff profile.
  final List<StaffAvailability> availabilities;

  /// Appointments with histories produced by domain lifecycle actions.
  final List<Appointment> appointments;

  /// Every document id in this scenario, including linked account profile ids.
  final Set<String> demoRecordIds;

  /// Whether [recordId] belongs to this demo-only data set.
  bool isDemoRecord(String recordId) => demoRecordIds.contains(recordId);

  @override
  List<Object?> get props => [
    referenceDate,
    [clinic.id, clinic.name],
    branches
        .map(
          (Branch branch) => [
            branch.id,
            branch.name,
            branch.clinicId,
            branch.address,
            branch.workingHours,
          ],
        )
        .toList(),
    departments
        .map(
          (Department department) => [
            department.id,
            department.name,
            department.branchId,
          ],
        )
        .toList(),
    services
        .map(
          (MedicalService service) => [
            service.id,
            service.name,
            service.departmentId,
            service.branchId,
            service.kind,
            service.duration,
            service.fee,
          ],
        )
        .toList(),
    staff
        .map(
          (Staff member) => [
            member.id,
            member.fullName,
            member.email,
            member.role,
            member.branchId,
            member.departmentId,
            member.serviceIds,
          ],
        )
        .toList(),
    patients
        .map((Patient patient) => [patient.id, patient.fullName, patient.email])
        .toList(),
    availabilities,
    appointments,
  ];
}
