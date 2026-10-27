import 'package:clinic_appointment_system/features/users/data/models/user_model.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patient_model.g.dart';

/// The stored form of a patient profile.
@JsonSerializable()
final class PatientModel extends Patient with UserModel {
  /// Creates a patient profile model.
  const PatientModel({
    required super.id,
    required super.fullName,
    required super.email,
  });

  /// Creates the model that stores [patient].
  PatientModel.fromEntity(Patient patient)
    : this(id: patient.id, fullName: patient.fullName, email: patient.email);

  /// Creates a profile model from stored document fields.
  factory PatientModel.fromJson(Map<String, dynamic> json) =>
      _$PatientModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PatientModelToJson(this);
}
