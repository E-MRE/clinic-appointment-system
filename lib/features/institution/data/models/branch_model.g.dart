// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BranchModel _$BranchModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BranchModel', json, ($checkedConvert) {
      final val = BranchModel(
        id: $checkedConvert('id', (v) => v as String),
        clinicId: $checkedConvert('clinicId', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        address: $checkedConvert('address', (v) => v as String),
        workingHours: $checkedConvert(
          'workingHours',
          (v) =>
              const WorkingHoursConverter().fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$BranchModelToJson(
  BranchModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'clinicId': instance.clinicId,
  'address': instance.address,
  'workingHours': const WorkingHoursConverter().toJson(instance.workingHours),
};
