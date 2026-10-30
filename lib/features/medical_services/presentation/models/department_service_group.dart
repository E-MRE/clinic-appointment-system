import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';

/// Group of medical services belonging to a department on mobile views.
final class DepartmentServiceGroup {
  /// Creates a department-service group.
  const DepartmentServiceGroup({
    required this.departmentName,
    required this.services,
  });

  /// Name of the department, or fallback name for unassigned services.
  final String departmentName;

  /// Ordered medical services within this department group.
  final List<MedicalService> services;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DepartmentServiceGroup &&
            runtimeType == other.runtimeType &&
            departmentName == other.departmentName;
  }

  @override
  int get hashCode => departmentName.hashCode;

  @override
  String toString() =>
      'DepartmentServiceGroup(departmentName: $departmentName, count: ${services.length})';
}
