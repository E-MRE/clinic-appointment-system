import 'package:clinic_appointment_system/features/users/domain/entities/admin.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:json_annotation/json_annotation.dart';

/// An immutable user profile. Subclasses provide their role, which decides
/// what the user may do.
abstract class User {
  /// Creates a profile from already validated values.
  const User({required this.id, required this.fullName, required this.email});

  /// Creates the appropriate profile for its stored role.
  factory User.fromJson(Map<String, dynamic> json) {
    return switch (UserRole.fromStorage(json['role'] as String)) {
      UserRole.patient => Patient.fromJson(json),
      UserRole.admin => Admin.fromJson(json),
      UserRole.doctor => Doctor.fromJson(json),
      UserRole.technician => Technician.fromJson(json),
    };
  }

  /// The unique profile identifier (the authentication uid).
  @JsonKey(required: true, includeToJson: false)
  final String id;

  /// The profile's full name.
  @JsonKey(required: true)
  final String fullName;

  /// The profile's email address.
  @JsonKey(required: true)
  final String email;

  /// The role supplied by the concrete profile type.
  UserRole get role;
}
