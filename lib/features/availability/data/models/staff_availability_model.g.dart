// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_availability_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffAvailabilityModel _$StaffAvailabilityModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('StaffAvailabilityModel', json, ($checkedConvert) {
  final val = StaffAvailabilityModel(
    branchId: $checkedConvert('branchId', (v) => v as String),
    weekly: $checkedConvert(
      'weekly',
      (v) => const WeeklyWindowsConverter().fromJson(v as Map<String, dynamic>),
    ),
    oneOff: $checkedConvert(
      'oneOff',
      (v) => const OneOffWindowsConverter().fromJson(v as List),
    ),
  );
  return val;
});

Map<String, dynamic> _$StaffAvailabilityModelToJson(
  StaffAvailabilityModel instance,
) => <String, dynamic>{
  'branchId': instance.branchId,
  'weekly': const WeeklyWindowsConverter().toJson(instance.weekly),
  'oneOff': const OneOffWindowsConverter().toJson(instance.oneOff),
};
