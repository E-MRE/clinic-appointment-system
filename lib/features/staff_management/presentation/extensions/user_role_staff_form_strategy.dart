import 'package:clinic_appointment_system/features/staff_management/presentation/strategies/doctor_form_strategy.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/strategies/staff_form_strategy.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/strategies/technician_form_strategy.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';

/// Selects the role-specific staff form strategy.
extension UserRoleStaffFormStrategy on UserRole {
  /// The strategy for this staff role. Staff forms never use patient or admin;
  /// requesting either throws [UnsupportedError].
  StaffFormStrategy get staffFormStrategy {
    return switch (this) {
      UserRole.doctor => const DoctorFormStrategy(),
      UserRole.technician => const TechnicianFormStrategy(),
      UserRole.patient || UserRole.admin => throw UnsupportedError(
        'Staff forms do not support $name',
      ),
    };
  }
}
