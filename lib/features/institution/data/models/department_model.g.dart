// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentModel _$DepartmentModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DepartmentModel', json, ($checkedConvert) {
      final val = DepartmentModel(
        id: $checkedConvert('id', (v) => v as String),
        branchId: $checkedConvert('branchId', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$DepartmentModelToJson(DepartmentModel instance) =>
    <String, dynamic>{'name': instance.name, 'branchId': instance.branchId};
