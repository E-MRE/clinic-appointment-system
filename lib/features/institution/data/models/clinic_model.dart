import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:json_annotation/json_annotation.dart';

part 'clinic_model.g.dart';

/// The Firestore representation of a clinic.
@JsonSerializable()
final class ClinicModel extends Clinic {
  /// Creates a clinic model with its document identifier and stored fields.
  const ClinicModel({required super.id, required super.name});

  /// Creates the stored model for [clinic].
  ClinicModel.fromEntity(Clinic clinic)
    : this(id: clinic.id, name: clinic.name);

  /// Creates a clinic model from stored fields and the document id.
  factory ClinicModel.fromJson(Map<String, dynamic> json) =>
      _$ClinicModelFromJson(json);

  @JsonKey(includeToJson: false)
  @override
  String get id => super.id;

  Map<String, dynamic> toJson() => _$ClinicModelToJson(this);
}
