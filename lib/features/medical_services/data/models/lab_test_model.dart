import 'package:clinic_appointment_system/features/medical_services/data/converters/fasting_hours_converter.dart';
import 'package:clinic_appointment_system/features/medical_services/data/converters/money_converter.dart';
import 'package:clinic_appointment_system/features/medical_services/data/converters/service_duration_converter.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/medical_service_model.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/lab_result_time.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/fasting_hours.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lab_test_model.g.dart';

/// Stored form of a laboratory diagnostic test service.
@JsonSerializable()
final class LabTestModel extends LabTest with MedicalServiceModel {
  /// Creates a laboratory test model.
  const LabTestModel({
    required super.id,
    required super.name,
    required super.departmentId,
    required super.branchId,
    required super.duration,
    required super.fee,
    required super.resultTime,
    super.fastingHours,
  });

  /// Creates a laboratory test model from an existing [service] entity.
  LabTestModel.fromEntity(LabTest service)
    : this(
        id: service.id,
        name: service.name,
        departmentId: service.departmentId,
        branchId: service.branchId,
        duration: service.duration,
        fee: service.fee,
        resultTime: service.resultTime,
        fastingHours: service.fastingHours,
      );

  /// Creates a laboratory test model from stored document fields.
  ///
  /// `requiresFasting` is derived from `fastingHours`; the Firestore rules
  /// keep the stored flag consistent with it.
  factory LabTestModel.fromJson(Map<String, dynamic> json) =>
      _$LabTestModelFromJson(json);

  @override
  @JsonKey(includeIfNull: false)
  @FastingHoursConverter()
  FastingHours? get fastingHours => super.fastingHours;

  @override
  @JsonKey(includeFromJson: false, includeToJson: true)
  bool get requiresFasting => super.requiresFasting;

  @override
  Map<String, dynamic> toJson() => _$LabTestModelToJson(this);
}
