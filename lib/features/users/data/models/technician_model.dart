import 'package:clinic_appointment_system/features/users/data/models/user_model.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'technician_model.g.dart';

/// The stored form of a technician profile.
@JsonSerializable()
final class TechnicianModel extends Technician with UserModel {
  /// Creates a technician profile model.
  const TechnicianModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.branchId,
    required super.departmentId,
  });

  /// Creates a profile model from stored document fields.
  factory TechnicianModel.fromJson(Map<String, dynamic> json) =>
      _$TechnicianModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TechnicianModelToJson(this);
}
