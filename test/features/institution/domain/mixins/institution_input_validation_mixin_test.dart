import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/institution_validation_probe.dart';

void main() {
  test('requires a non-blank name after trimming', () {
    final validation = InstitutionValidationProbe();

    expect(validation.nameError('  '), InstitutionErrorCode.nameRequired);
    expect(validation.nameError(' Clinic '), isNull);
  });

  test('requires a non-blank branch address after trimming', () {
    final validation = InstitutionValidationProbe();

    expect(validation.addressError('  '), InstitutionErrorCode.addressRequired);
    expect(validation.addressError('  Main Street  '), isNull);
  });

  test('throws an institution exception for an invalid code', () {
    final validation = InstitutionValidationProbe();

    expect(
      () => validation.ensureValid(InstitutionErrorCode.nameRequired),
      throwsA(
        isA<InstitutionException>().having(
          (error) => error.code,
          'code',
          InstitutionErrorCode.nameRequired,
        ),
      ),
    );
    expect(() => validation.ensureValid(null), returnsNormally);
  });
}
