// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_test_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabTestModel _$LabTestModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'LabTestModel',
      json,
      ($checkedConvert) {
        final val = LabTestModel(
          id: $checkedConvert('id', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          departmentId: $checkedConvert('departmentId', (v) => v as String),
          branchId: $checkedConvert('branchId', (v) => v as String),
          duration: $checkedConvert(
            'durationMinutes',
            (v) =>
                const ServiceDurationConverter().fromJson((v as num).toInt()),
          ),
          fee: $checkedConvert(
            'feeKurus',
            (v) => const MoneyConverter().fromJson((v as num).toInt()),
          ),
          resultTime: $checkedConvert(
            'resultTime',
            (v) => $enumDecode(_$LabResultTimeEnumMap, v),
          ),
          fastingHours: $checkedConvert(
            'fastingHours',
            (v) => _$JsonConverterFromJson<Map<String, dynamic>, FastingHours>(
              v,
              const FastingHoursConverter().fromJson,
            ),
          ),
        );
        return val;
      },
      fieldKeyMap: const {'duration': 'durationMinutes', 'fee': 'feeKurus'},
    );

Map<String, dynamic> _$LabTestModelToJson(
  LabTestModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'departmentId': instance.departmentId,
  'branchId': instance.branchId,
  'resultTime': _$LabResultTimeEnumMap[instance.resultTime]!,
  'kind': _$MedicalServiceKindEnumMap[instance.kind]!,
  'durationMinutes': const ServiceDurationConverter().toJson(instance.duration),
  'feeKurus': const MoneyConverter().toJson(instance.fee),
  'fastingHours': ?_$JsonConverterToJson<Map<String, dynamic>, FastingHours>(
    instance.fastingHours,
    const FastingHoursConverter().toJson,
  ),
  'requiresFasting': instance.requiresFasting,
};

const _$LabResultTimeEnumMap = {
  LabResultTime.sameDay: 'sameDay',
  LabResultTime.oneDay: 'oneDay',
  LabResultTime.twoDays: 'twoDays',
  LabResultTime.threeDays: 'threeDays',
  LabResultTime.oneWeek: 'oneWeek',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$MedicalServiceKindEnumMap = {
  MedicalServiceKind.examination: 'examination',
  MedicalServiceKind.radiology: 'radiology',
  MedicalServiceKind.lab: 'lab',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
