// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientModel _$PatientModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PatientModel', json, ($checkedConvert) {
      final val = PatientModel(
        id: $checkedConvert('id', (v) => v as String),
        fullName: $checkedConvert('fullName', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$PatientModelToJson(PatientModel instance) =>
    <String, dynamic>{
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
