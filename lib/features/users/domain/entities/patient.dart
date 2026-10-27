import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patient.g.dart';

/// A patient profile.
@JsonSerializable()
final class Patient extends User {
  /// Creates a patient profile.
  const Patient({
    required super.id,
    required super.fullName,
    required super.email,
  });

  /// Creates a profile from stored JSON fields.
  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);

  /// Converts this profile to stored JSON fields.
  Map<String, dynamic> toJson() => _$PatientToJson(this);

  /// The profile role.
  @override
  @JsonKey(includeFromJson: false, includeToJson: true)
  UserRole get role => UserRole.patient;
}
