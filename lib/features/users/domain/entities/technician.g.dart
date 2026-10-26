// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technician.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Technician _$TechnicianFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Technician', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'fullName',
          'email',
          'branchId',
          'departmentId',
        ],
      );
      final val = Technician(
        id: $checkedConvert('id', (v) => v as String),
        fullName: $checkedConvert('fullName', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String),
        branchId: $checkedConvert('branchId', (v) => v as String),
        departmentId: $checkedConvert('departmentId', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$TechnicianToJson(Technician instance) =>
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
