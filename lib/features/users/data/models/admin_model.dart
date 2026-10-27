import 'package:clinic_appointment_system/features/users/data/models/user_model.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/admin.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_model.g.dart';

/// The stored form of an admin profile.
@JsonSerializable()
final class AdminModel extends Admin with UserModel {
  /// Creates an admin profile model.
  const AdminModel({
    required super.id,
    required super.fullName,
    required super.email,
  });

  /// Creates a profile model from stored document fields.
  factory AdminModel.fromJson(Map<String, dynamic> json) =>
      _$AdminModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AdminModelToJson(this);
}
