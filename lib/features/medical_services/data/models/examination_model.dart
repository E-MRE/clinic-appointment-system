import 'package:clinic_appointment_system/features/medical_services/data/converters/money_converter.dart';
import 'package:clinic_appointment_system/features/medical_services/data/converters/service_duration_converter.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/medical_service_model.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:json_annotation/json_annotation.dart';

part 'examination_model.g.dart';

/// Stored form of an examination consultation service.
@JsonSerializable()
final class ExaminationModel extends Examination with MedicalServiceModel {
  /// Creates an examination service model.
  const ExaminationModel({
    required super.id,
    required super.name,
    required super.departmentId,
    required super.branchId,
    required super.duration,
    required super.fee,
  });

  /// Creates an examination model from an existing [service] entity.
  ExaminationModel.fromEntity(Examination service)
    : this(
        id: service.id,
        name: service.name,
        departmentId: service.departmentId,
        branchId: service.branchId,
        duration: service.duration,
        fee: service.fee,
      );

  /// Creates an examination model from stored document fields.
  factory ExaminationModel.fromJson(Map<String, dynamic> json) =>
      _$ExaminationModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ExaminationModelToJson(this);
}
