import 'package:clinic_appointment_system/features/users/data/models/user_model.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'doctor_model.g.dart';

/// The stored form of a doctor profile.
@JsonSerializable()
final class DoctorModel extends Doctor with UserModel {
  /// Creates a doctor profile model.
  const DoctorModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.branchId,
    required super.departmentId,
    required super.serviceIds,
    required super.specialty,
  });

  /// Creates the model that stores [doctor].
  DoctorModel.fromEntity(Doctor doctor)
    : this(
        id: doctor.id,
        fullName: doctor.fullName,
        email: doctor.email,
        branchId: doctor.branchId,
        departmentId: doctor.departmentId,
        serviceIds: doctor.serviceIds,
        specialty: doctor.specialty,
      );

  /// Creates a profile model from stored document fields.
  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);

  @override
  @JsonKey(defaultValue: <String>[])
  List<String> get serviceIds => super.serviceIds;

  @override
  @JsonKey(defaultValue: '')
  String get specialty => super.specialty;

  @override
  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);
}
