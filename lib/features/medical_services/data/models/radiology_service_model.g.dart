// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radiology_service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RadiologyServiceModel _$RadiologyServiceModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'RadiologyServiceModel',
  json,
  ($checkedConvert) {
    final val = RadiologyServiceModel(
      id: $checkedConvert('id', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String),
      departmentId: $checkedConvert('departmentId', (v) => v as String),
      branchId: $checkedConvert('branchId', (v) => v as String),
      duration: $checkedConvert(
        'durationMinutes',
        (v) => const ServiceDurationConverter().fromJson((v as num).toInt()),
      ),
      fee: $checkedConvert(
        'feeKurus',
        (v) => const MoneyConverter().fromJson((v as num).toInt()),
      ),
      modality: $checkedConvert(
        'modality',
        (v) => $enumDecode(_$RadiologyModalityEnumMap, v),
      ),
      preparationNote: $checkedConvert('preparationNote', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {'duration': 'durationMinutes', 'fee': 'feeKurus'},
);

Map<String, dynamic> _$RadiologyServiceModelToJson(
  RadiologyServiceModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'departmentId': instance.departmentId,
  'branchId': instance.branchId,
  'modality': _$RadiologyModalityEnumMap[instance.modality]!,
  'kind': _$MedicalServiceKindEnumMap[instance.kind]!,
  'durationMinutes': const ServiceDurationConverter().toJson(instance.duration),
  'feeKurus': const MoneyConverter().toJson(instance.fee),
  'preparationNote': ?instance.preparationNote,
};

const _$RadiologyModalityEnumMap = {
  RadiologyModality.xRay: 'xRay',
  RadiologyModality.ultrasound: 'ultrasound',
  RadiologyModality.mri: 'mri',
  RadiologyModality.ct: 'ct',
};

const _$MedicalServiceKindEnumMap = {
  MedicalServiceKind.examination: 'examination',
  MedicalServiceKind.radiology: 'radiology',
  MedicalServiceKind.lab: 'lab',
};
