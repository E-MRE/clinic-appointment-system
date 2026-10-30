import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/medical_services/data/converters/money_converter.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const converter = MoneyConverter();

  test('converts valid kurus to and from integer', () {
    final money = converter.fromJson(85000);
    expect(money, Money.kurus(85000));
    expect(money.kurus, 85000);
    expect(converter.toJson(money), 85000);
  });

  test('throws for out-of-range fee values', () {
    for (final kurus in [0, 99, 10000001, -500]) {
      expect(
        () => converter.fromJson(kurus),
        throwsA(
          isA<InstitutionException>().having(
            (error) => error.code,
            'code',
            InstitutionErrorCode.invalidFee,
          ),
        ),
      );
    }
  });
}
