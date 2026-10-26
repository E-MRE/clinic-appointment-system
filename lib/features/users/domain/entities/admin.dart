import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin.g.dart';

/// An admin profile.
@JsonSerializable()
final class Admin extends User {
  /// Creates a admin profile.
  const Admin({
    required super.id,
    required super.fullName,
    required super.email,
  });

  /// Creates a profile from stored JSON fields.
  factory Admin.fromJson(Map<String, dynamic> json) => _$AdminFromJson(json);

  /// Converts this profile to stored JSON fields.
  Map<String, dynamic> toJson() => _$AdminToJson(this);

  /// The profile role.
  @override
  @JsonKey(includeFromJson: false, includeToJson: true)
  UserRole get role => UserRole.admin;
}
