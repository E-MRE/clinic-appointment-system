// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'examination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExaminationModel _$ExaminationModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ExaminationModel',
      json,
      ($checkedConvert) {
        final val = ExaminationModel(
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
        );
        return val;
      },
      fieldKeyMap: const {'duration': 'durationMinutes', 'fee': 'feeKurus'},
    );

Map<String, dynamic> _$ExaminationModelToJson(
  ExaminationModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'departmentId': instance.departmentId,
  'branchId': instance.branchId,
  'kind': _$MedicalServiceKindEnumMap[instance.kind]!,
  'durationMinutes': const ServiceDurationConverter().toJson(instance.duration),
  'feeKurus': const MoneyConverter().toJson(instance.fee),
};

const _$MedicalServiceKindEnumMap = {
  MedicalServiceKind.examination: 'examination',
  MedicalServiceKind.radiology: 'radiology',
  MedicalServiceKind.lab: 'lab',
};
