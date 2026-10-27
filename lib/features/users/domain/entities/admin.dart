import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';

/// An admin profile.
base class Admin extends User {
  /// Creates an admin profile.
  const Admin({
    required super.id,
    required super.fullName,
    required super.email,
  });

  /// The profile role.
  @override
  UserRole get role => UserRole.admin;
}
