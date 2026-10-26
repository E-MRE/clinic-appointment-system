// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Admin _$AdminFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Admin', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'fullName', 'email']);
      final val = Admin(
        id: $checkedConvert('id', (v) => v as String),
        fullName: $checkedConvert('fullName', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AdminToJson(Admin instance) => <String, dynamic>{
  'fullName': instance.fullName,
  'email': instance.email,
  'role': _$UserRoleEnumMap[instance.role]!,
};

const _$UserRoleEnumMap = {
  UserRole.patient: 'patient',
  UserRole.doctor: 'doctor',
  UserRole.technician: 'technician',
  UserRole.admin: 'admin',
};
