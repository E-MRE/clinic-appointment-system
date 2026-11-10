import 'package:clinic_appointment_system/core/extensions/turkish_alphabetical_comparison.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/institution_record.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_department_summary.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// An immutable snapshot of every clinic's branches, departments, services
/// and staff, with the lookups the patient screens need.
final class PatientCatalog {
  /// Indexes records by id and sorts services and departments by Turkish name.
  factory PatientCatalog({
    required List<Branch> branches,
    required List<Department> departments,
    required List<MedicalService> services,
    required List<Staff> staff,
  }) {
    final branchesById = {for (final branch in branches) branch.id: branch};
    final departmentsById = {
      for (final department in departments) department.id: department,
    };
    final servicesById = {for (final service in services) service.id: service};
    final staffById = {for (final member in staff) member.id: member};

    final sortedServices = <MedicalService>[...services]..sort(_byName);
    final sortedDepartments = <Department>[...departments]..sort(_byName);

    final immutableServices = List<MedicalService>.unmodifiable(sortedServices);
    final immutableDepartments = List<Department>.unmodifiable(
      sortedDepartments,
    );
    final immutableStaff = List<Staff>.unmodifiable(staff);

    return PatientCatalog._(
      branchesById: branchesById,
      departmentsById: departmentsById,
      servicesById: servicesById,
      staffById: staffById,
      departmentList: immutableDepartments,
      staffList: immutableStaff,
      services: immutableServices,
    );
  }

  PatientCatalog._({
    required Map<String, Branch> branchesById,
    required Map<String, Department> departmentsById,
    required Map<String, MedicalService> servicesById,
    required Map<String, Staff> staffById,
    required List<Department> departmentList,
    required List<Staff> staffList,
    required this.services,
  }) : _branches = branchesById,
       _departments = departmentsById,
       _services = servicesById,
       _staff = staffById,
       _departmentList = departmentList,
       _staffList = staffList;

  final Map<String, Branch> _branches;
  final Map<String, Department> _departments;
  final Map<String, MedicalService> _services;
  final Map<String, Staff> _staff;
  final List<Department> _departmentList;
  final List<Staff> _staffList;

  /// Every service, sorted by Turkish name.
  final List<MedicalService> services;

  /// The branch identified by [id], or null when unknown.
  Branch? branchById(String id) => _branches[id];

  /// The department identified by [id], or null when unknown.
  Department? departmentById(String id) => _departments[id];

  /// The service identified by [id], or null when unknown.
  MedicalService? serviceById(String id) => _services[id];

  /// The staff member identified by [id], or null when unknown.
  Staff? staffById(String id) => _staff[id];

  /// Staff assigned to [service] who work in the service's branch.
  List<Staff> staffFor(MedicalService service) {
    return List<Staff>.unmodifiable(
      _staffList.where(
        (Staff member) =>
            member.branchId == service.branchId &&
            member.serviceIds.contains(service.id),
      ),
    );
  }

  /// Departments with at least one bookable service, sorted by Turkish name.
  /// A service is bookable when [staffFor] returns at least one member.
  List<PatientDepartmentSummary> get departmentsWithServiceCounts {
    final offered = <String, List<MedicalService>>{};
    for (final service in services) {
      if (staffFor(service).isNotEmpty) {
        offered.putIfAbsent(service.departmentId, () => []).add(service);
      }
    }
    final summaries = <PatientDepartmentSummary>[];
    for (final department in _departmentList) {
      final items = offered[department.id];
      if (items != null) {
        summaries.add(
          PatientDepartmentSummary(
            department: department,
            serviceCount: items.length,
          ),
        );
      }
    }
    return List<PatientDepartmentSummary>.unmodifiable(summaries);
  }

  static int _byName(InstitutionRecord first, InstitutionRecord second) {
    return first.name.compareTurkishAlphabetically(second.name);
  }
}
