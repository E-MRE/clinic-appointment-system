// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DoctorModel', json, ($checkedConvert) {
      final val = DoctorModel(
        id: $checkedConvert('id', (v) => v as String),
        fullName: $checkedConvert('fullName', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String),
        branchId: $checkedConvert('branchId', (v) => v as String),
        departmentId: $checkedConvert('departmentId', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$DoctorModelToJson(DoctorModel instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
      'branchId': instance.branchId,
      'departmentId': instance.departmentId,
      'role': _$UserRoleEnumMap[instance.role]!,
    };

const _$UserRoleEnumMap = {
  UserRole.patient: 'patient',
  UserRole.doctor: 'doctor',
  UserRole.technician: 'technician',
  UserRole.admin: 'admin',
};
