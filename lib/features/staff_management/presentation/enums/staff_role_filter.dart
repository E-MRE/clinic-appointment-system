import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';

/// Role choices for staff lists.
enum StaffRoleFilter {
  /// Matches every staff role.
  all(null),

  /// Matches doctors only.
  doctor(UserRole.doctor),

  /// Matches technicians only.
  technician(UserRole.technician);

  const StaffRoleFilter(this.role);

  /// The matched role, or null for all staff.
  final UserRole? role;
}
