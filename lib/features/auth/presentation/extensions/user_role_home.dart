import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';

/// Maps domain roles to presentation locations.
extension UserRoleHome on UserRole {
  /// The home location served by this role.
  String get homePath {
    return switch (this) {
      UserRole.patient => AppRoutes.patientHome,
      UserRole.doctor || UserRole.technician => AppRoutes.staffHome,
      UserRole.admin => AppRoutes.adminHome,
    };
  }
}
