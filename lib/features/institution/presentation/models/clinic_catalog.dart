import 'package:clinic_appointment_system/core/extensions/turkish_alphabetical_comparison.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/institution_record.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// An immutable snapshot of clinics, branches, departments, services and staff.
final class ClinicCatalog {
  /// Sorts the directory records and indexes each kind of record by id.
  factory ClinicCatalog({
    required List<Clinic> clinics,
    required List<Branch> branches,
    required List<Department> departments,
    required List<MedicalService> services,
    required List<Staff> staff,
  }) {
    final clinicsById = {for (final clinic in clinics) clinic.id: clinic};
    final branchesById = {for (final branch in branches) branch.id: branch};
    final departmentsById = {
      for (final department in departments) department.id: department,
    };
    final servicesById = {for (final service in services) service.id: service};
    final staffById = {for (final member in staff) member.id: member};

    final sortedClinics = <Clinic>[...clinics]..sort(_byName);
    final sortedBranches = <Branch>[...branches]..sort(_byName);
    final sortedDepartments = <Department>[...departments]..sort(_byName);
    final sortedServices = <MedicalService>[...services]..sort(_byName);
    final sortedStaff = <Staff>[...staff]
      ..sort(
        (Staff first, Staff second) =>
            first.fullName.compareTurkishAlphabetically(second.fullName),
      );

    return ClinicCatalog._(
      clinicsById: clinicsById,
      branchesById: branchesById,
      departmentsById: departmentsById,
      servicesById: servicesById,
      staffById: staffById,
      clinics: List<Clinic>.unmodifiable(sortedClinics),
      branches: List<Branch>.unmodifiable(sortedBranches),
      departments: List<Department>.unmodifiable(sortedDepartments),
      services: List<MedicalService>.unmodifiable(sortedServices),
      staff: List<Staff>.unmodifiable(sortedStaff),
    );
  }

  ClinicCatalog._({
    required Map<String, Clinic> clinicsById,
    required Map<String, Branch> branchesById,
    required Map<String, Department> departmentsById,
    required Map<String, MedicalService> servicesById,
    required Map<String, Staff> staffById,
    required this.clinics,
    required this.branches,
    required this.departments,
    required this.services,
    required this.staff,
  }) : _clinics = Map<String, Clinic>.unmodifiable(clinicsById),
       _branches = Map<String, Branch>.unmodifiable(branchesById),
       _departments = Map<String, Department>.unmodifiable(departmentsById),
       _services = Map<String, MedicalService>.unmodifiable(servicesById),
       _staff = Map<String, Staff>.unmodifiable(staffById);

  final Map<String, Clinic> _clinics;
  final Map<String, Branch> _branches;
  final Map<String, Department> _departments;
  final Map<String, MedicalService> _services;
  final Map<String, Staff> _staff;

  /// Every clinic, sorted by Turkish name.
  final List<Clinic> clinics;

  /// Every branch, sorted by Turkish name.
  final List<Branch> branches;

  /// Every department, sorted by Turkish name.
  final List<Department> departments;

  /// Every medical service, sorted by Turkish name.
  final List<MedicalService> services;

  /// Every staff member, sorted by Turkish full name.
  final List<Staff> staff;

  /// The clinic identified by [id], or null when unknown.
  Clinic? clinicById(String id) => _clinics[id];

  /// The branch identified by [id], or null when unknown.
  Branch? branchById(String id) => _branches[id];

  /// The department identified by [id], or null when unknown.
  Department? departmentById(String id) => _departments[id];

  /// The service identified by [id], or null when unknown.
  MedicalService? serviceById(String id) => _services[id];

  /// The staff member identified by [id], or null when unknown.
  Staff? staffById(String id) => _staff[id];

  static int _byName(InstitutionRecord first, InstitutionRecord second) {
    return first.name.compareTurkishAlphabetically(second.name);
  }
}
