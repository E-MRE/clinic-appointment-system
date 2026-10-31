import 'package:clinic_appointment_system/features/staff_management/presentation/enums/staff_role_filter.dart';
import 'package:equatable/equatable.dart';

/// Immutable role and department-name selection for staff lists.
final class StaffFilter extends Equatable {
  /// Creates a filter defaulting to every role and department.
  const StaffFilter({this.role = StaffRoleFilter.all, this.departmentName});

  /// The selected role category.
  final StaffRoleFilter role;

  /// The department name shared across branches, or null for all departments.
  final String? departmentName;

  /// Copies the selection, preserving unspecified values.
  StaffFilter copyWith({StaffRoleFilter? role, String? departmentName}) {
    return StaffFilter(
      role: role ?? this.role,
      departmentName: departmentName ?? this.departmentName,
    );
  }

  /// Clears the department selection while preserving the role.
  StaffFilter withoutDepartment() => StaffFilter(role: role);

  @override
  List<Object?> get props => [role, departmentName];
}
