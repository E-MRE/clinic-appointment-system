import 'package:clinic_appointment_system/features/staff_management/presentation/enums/staff_role_filter.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// Matches staff against a role filter.
extension StaffRoleFilterMatching on StaffRoleFilter {
  /// Whether [staff] belongs to this role category.
  bool matches(Staff staff) => role == null || staff.role == role;
}
