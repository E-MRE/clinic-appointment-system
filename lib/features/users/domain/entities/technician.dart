import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'technician.g.dart';

/// A technician profile.
@JsonSerializable()
final class Technician extends Staff {
  /// Creates a technician profile.
  const Technician({
    required super.id,
    required super.fullName,
    required super.email,
    required super.branchId,
    required super.departmentId,
  });

  /// Creates a profile from stored JSON fields.
  factory Technician.fromJson(Map<String, dynamic> json) =>
      _$TechnicianFromJson(json);

  /// Converts this profile to stored JSON fields.
  Map<String, dynamic> toJson() => _$TechnicianToJson(this);

  /// The profile role.
  @override
  @JsonKey(includeFromJson: false, includeToJson: true)
  UserRole get role => UserRole.technician;
}
