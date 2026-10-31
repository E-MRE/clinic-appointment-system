import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/enums/staff_role_filter.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/extensions/staff_role_filter_matching.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/models/staff_filter.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// Clinic-scoped staff counts, filters and catalogue name lookups.
final class StaffListOverview {
  /// Keeps staff belonging to [branches] and snapshots the supplied catalogues.
  StaffListOverview({
    required List<Staff> staff,
    required List<Branch> branches,
    required List<Department> departments,
    required List<MedicalService> services,
  }) : _branches = {for (final branch in branches) branch.id: branch},
       _departments = {
         for (final department in departments) department.id: department,
       },
       _services = {for (final service in services) service.id: service},
       branchCount = branches.length {
    _staff = List<Staff>.unmodifiable(
      staff.where((Staff member) => _branches.containsKey(member.branchId)),
    );
  }

  final Map<String, Branch> _branches;
  final Map<String, Department> _departments;
  final Map<String, MedicalService> _services;
  late final List<Staff> _staff;

  /// Staff whose branch belongs to the selected clinic.
  List<Staff> get staff => _staff;

  /// Number of branches in the selected clinic, including branches without staff.
  final int branchCount;

  /// Number of staff matching [filter] in the selected clinic.
  int count(StaffRoleFilter filter) => _staff.where(filter.matches).length;

  /// Number of doctors in the selected clinic.
  int get doctorCount => count(StaffRoleFilter.doctor);

  /// Number of technicians in the selected clinic.
  int get technicianCount => count(StaffRoleFilter.technician);

  /// Distinct sorted names of known departments with at least one staff member.
  List<String> get departmentNames {
    final names = <String>{};
    for (final member in _staff) {
      final department = _departments[member.departmentId];
      if (department != null) {
        names.add(department.name);
      }
    }
    return List<String>.unmodifiable(names.toList()..sort());
  }

  /// Staff matching both role and department name, preserving source order.
  /// An unknown department name never matches a missing department record.
  List<Staff> filtered(StaffFilter filter) {
    return List<Staff>.unmodifiable(
      _staff.where((Staff member) {
        if (!filter.role.matches(member)) return false;
        final name = filter.departmentName;
        if (name == null) return true;
        return _departments[member.departmentId]?.name == name;
      }),
    );
  }

  /// The branch name for [staff], or an empty string when unknown.
  String branchName(Staff staff) => _branches[staff.branchId]?.name ?? '';

  /// The department name for [staff], or an empty string when unknown.
  String departmentName(Staff staff) =>
      _departments[staff.departmentId]?.name ?? '';

  /// Known service names in assignment order, skipping unknown identifiers.
  List<String> serviceNames(Staff staff) {
    final names = <String>[];
    for (final id in staff.serviceIds) {
      final service = _services[id];
      if (service != null) {
        names.add(service.name);
      }
    }
    return List<String>.unmodifiable(names);
  }
}
