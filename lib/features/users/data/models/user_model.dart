import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:json_annotation/json_annotation.dart';

/// The stored form of a user profile, shared by every concrete profile model.
/// The id comes from the document id and is never written; the role is
/// written so the document can be read back as the right model. A model must
/// provide [toJson].
base mixin UserModel on User {
  /// Converts this profile to stored document fields.
  Map<String, dynamic> toJson();

  @override
  @JsonKey(includeToJson: false)
  String get id => super.id;

  @override
  @JsonKey(includeFromJson: false, includeToJson: true)
  UserRole get role => super.role;
}
