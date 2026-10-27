import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';

/// A patient profile.
base class Patient extends User {
  /// Creates a patient profile.
  const Patient({
    required super.id,
    required super.fullName,
    required super.email,
  });

  /// The profile role.
  @override
  UserRole get role => UserRole.patient;
}
