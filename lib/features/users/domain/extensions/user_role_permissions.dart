import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:clinic_appointment_system/features/users/domain/models/role_permissions.dart';

/// Resolves the [RolePermissions] granted to a [UserRole].
extension UserRolePermissions on UserRole {
  /// The permissions this role grants.
  RolePermissions get permissions {
    return switch (this) {
      UserRole.patient => const RolePermissions.patient(),
      UserRole.doctor => const RolePermissions.doctor(),
      UserRole.technician => const RolePermissions.technician(),
      UserRole.admin => const RolePermissions.admin(),
    };
  }
}
