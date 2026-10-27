import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'doctor.g.dart';

/// A doctor profile.
@JsonSerializable()
final class Doctor extends Staff {
  /// Creates a doctor profile.
  const Doctor({
    required super.id,
    required super.fullName,
    required super.email,
    required super.branchId,
    required super.departmentId,
  });

  /// Creates a profile from stored JSON fields.
  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);

  /// Converts this profile to stored JSON fields.
  Map<String, dynamic> toJson() => _$DoctorToJson(this);

  /// The profile role.
  @override
  @JsonKey(includeFromJson: false, includeToJson: true)
  UserRole get role => UserRole.doctor;
}
