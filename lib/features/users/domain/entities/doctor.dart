import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';

/// A doctor profile.
base class Doctor extends Staff {
  /// Creates a doctor profile.
  const Doctor({
    required super.id,
    required super.fullName,
    required super.email,
    required super.branchId,
    required super.departmentId,
  });

  /// The profile role.
  @override
  UserRole get role => UserRole.doctor;
}
