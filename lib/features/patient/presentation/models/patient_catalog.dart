import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/institution_record.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_department_summary.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// An immutable snapshot of every clinic's branches, departments, services
/// and staff, with the lookups the patient screens need.
final class PatientCatalog {
  /// Indexes the supplied records by id and sorts services by name.
  PatientCatalog({
    required List<Branch> branches,
    required List<Department> departments,
    required List<MedicalService> services,
    required List<Staff> staff,
  }) : _branches = {for (final branch in branches) branch.id: branch},
       _departments = {
         for (final department in departments) department.id: department,
       },
       _services = {for (final service in services) service.id: service},
       _staff = {for (final member in staff) member.id: member},
       services = List<MedicalService>.unmodifiable(
         <MedicalService>[...services]..sort(_byName),
       ),
       _departmentList = List<Department>.unmodifiable(
         <Department>[...departments]..sort(_byName),
       ),
       _staffList = List<Staff>.unmodifiable(staff);

  final Map<String, Branch> _branches;
  final Map<String, Department> _departments;
  final Map<String, MedicalService> _services;
  final Map<String, Staff> _staff;
  final List<Department> _departmentList;
  final List<Staff> _staffList;

  /// Every service, sorted by name.
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

  /// Departments with at least one bookable service, sorted by name.
  /// A service is bookable when [staffFor] returns at least one member.
  List<PatientDepartmentSummary> get departmentsWithServiceCounts {
    final offered = <String, List<MedicalService>>{};
    for (final service in services) {
      if (staffFor(service).isNotEmpty) {
        offered.putIfAbsent(service.departmentId, () => []).add(service);
      }
    }
    return List<PatientDepartmentSummary>.unmodifiable([
      for (final department in _departmentList)
        if (offered[department.id] case final List<MedicalService> items)
          PatientDepartmentSummary(
            department: department,
            serviceCount: items.length,
          ),
    ]);
  }

  static int _byName(InstitutionRecord first, InstitutionRecord second) {
    return first.name.compareTo(second.name);
  }
}
