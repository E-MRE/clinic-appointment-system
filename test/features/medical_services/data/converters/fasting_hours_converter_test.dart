import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/medical_services/data/converters/fasting_hours_converter.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/fasting_hours.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const converter = FastingHoursConverter();

  test('converts valid fasting hours to and from map', () {
    final hours = converter.fromJson({'min': 8, 'max': 12});
    expect(hours, FastingHours(min: 8, max: 12));
    expect(converter.toJson(hours), {'min': 8, 'max': 12});
  });

  test('throws TypeError when min or max is missing or not an int', () {
    for (final invalid in [
      <String, dynamic>{'min': '8', 'max': 12},
      <String, dynamic>{'min': 8, 'max': '12'},
      <String, dynamic>{'min': 8},
      <String, dynamic>{'max': 12},
      <String, dynamic>{},
    ]) {
      expect(() => converter.fromJson(invalid), throwsA(isA<TypeError>()));
    }
  });

  test(
    'throws InstitutionException when bounds are inverted or out of range',
    () {
      for (final invalid in [
        {'min': 12, 'max': 8},
        {'min': 0, 'max': 12},
        {'min': 8, 'max': 25},
      ]) {
        expect(
          () => converter.fromJson(invalid),
          throwsA(
            isA<InstitutionException>().having(
              (error) => error.code,
              'code',
              InstitutionErrorCode.invalidFastingHours,
            ),
          ),
        );
      }
    },
  );
}
