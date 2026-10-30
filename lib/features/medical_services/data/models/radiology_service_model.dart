import 'package:clinic_appointment_system/features/medical_services/data/converters/money_converter.dart';
import 'package:clinic_appointment_system/features/medical_services/data/converters/service_duration_converter.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/medical_service_model.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';
import 'package:json_annotation/json_annotation.dart';

part 'radiology_service_model.g.dart';

/// Stored form of a radiology diagnostic imaging service.
@JsonSerializable()
final class RadiologyServiceModel extends RadiologyService
    with MedicalServiceModel {
  /// Creates a radiology service model.
  const RadiologyServiceModel({
    required super.id,
    required super.name,
    required super.departmentId,
    required super.branchId,
    required super.duration,
    required super.fee,
    required super.modality,
    super.preparationNote,
  });

  /// Creates a radiology model from an existing [service] entity.
  RadiologyServiceModel.fromEntity(RadiologyService service)
    : this(
        id: service.id,
        name: service.name,
        departmentId: service.departmentId,
        branchId: service.branchId,
        duration: service.duration,
        fee: service.fee,
        modality: service.modality,
        preparationNote: service.preparationNote,
      );

  /// Creates a radiology service model from stored document fields.
  factory RadiologyServiceModel.fromJson(Map<String, dynamic> json) =>
      _$RadiologyServiceModelFromJson(json);

  @override
  @JsonKey(includeIfNull: false)
  String? get preparationNote => super.preparationNote;

  @override
  Map<String, dynamic> toJson() => _$RadiologyServiceModelToJson(this);
}
