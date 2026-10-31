import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:easy_localization/easy_localization.dart';

/// Localized role names shared by staff list rows and filters.
extension UserRoleStaffLabel on UserRole {
  /// The stored role's display label without a name prefix.
  String get staffLabel => switch (this) {
    UserRole.doctor => LocaleKeys.roles_doctor.tr(),
    UserRole.technician => LocaleKeys.roles_technician.tr(),
    UserRole.admin => LocaleKeys.roles_admin.tr(),
    UserRole.patient => LocaleKeys.roles_patient.tr(),
  };
}
