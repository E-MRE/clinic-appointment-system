import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';

/// An immutable user profile. Subclasses provide their role, which decides
/// what the user may do.
abstract class User {
  /// Creates a profile from already validated values.
  const User({required this.id, required this.fullName, required this.email});

  /// The unique profile identifier (the authentication uid).
  final String id;

  /// The profile's full name.
  final String fullName;

  /// The profile's email address.
  final String email;

  /// The role supplied by the concrete profile type.
  UserRole get role;
}
