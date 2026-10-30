import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/fasting_hours.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FastingHours', () {
    test(
      'accepts valid bounds and rejects out-of-range or inverted ranges',
      () {
        final valid = FastingHours(min: 1, max: 24);
        expect(valid.min, 1);
        expect(valid.max, 24);
        expect(valid.isSingle, isFalse);

        final single = FastingHours(min: 24, max: 24);
        expect(single.min, 24);
        expect(single.max, 24);
        expect(single.isSingle, isTrue);

        expect(
          () => FastingHours(min: 0, max: 1),
          throwsA(
            isA<InstitutionException>().having(
              (error) => error.code,
              'code',
              InstitutionErrorCode.invalidFastingHours,
            ),
          ),
        );
        expect(
          () => FastingHours(min: 1, max: 25),
          throwsA(
            isA<InstitutionException>().having(
              (error) => error.code,
              'code',
              InstitutionErrorCode.invalidFastingHours,
            ),
          ),
        );
        expect(
          () => FastingHours(min: 12, max: 8),
          throwsA(
            isA<InstitutionException>().having(
              (error) => error.code,
              'code',
              InstitutionErrorCode.invalidFastingHours,
            ),
          ),
        );
      },
    );

    test('parse handles single hours, hyphens and en dashes', () {
      final single = FastingHours.parse('8');
      expect(single.min, 8);
      expect(single.max, 8);
      expect(single.isSingle, isTrue);

      final hyphen = FastingHours.parse('8-12');
      expect(hyphen.min, 8);
      expect(hyphen.max, 12);

      final enDash = FastingHours.parse('8\u201312');
      expect(enDash.min, 8);
      expect(enDash.max, 12);

      final spaces = FastingHours.parse(' 8 - 12 ');
      expect(spaces.min, 8);
      expect(spaces.max, 12);
    });

    test('parse rejects invalid patterns and out-of-range inputs', () {
      final invalidInputs = <String>[
        '12-8',
        '8-',
        '-8',
        '8-12-14',
        '',
        '   ',
        'abc',
      ];

      for (final input in invalidInputs) {
        expect(
          () => FastingHours.parse(input),
          throwsA(
            isA<InstitutionException>().having(
              (error) => error.code,
              'code',
              InstitutionErrorCode.invalidFastingHours,
            ),
          ),
          reason: 'Expected "$input" to be rejected',
        );
      }
    });

    test('equality and hashCode compare min and max values', () {
      final f1 = FastingHours(min: 8, max: 12);
      final f2 = FastingHours.parse('8-12');
      final f3 = FastingHours(min: 8, max: 10);

      expect(f1, f2);
      expect(f1.hashCode, f2.hashCode);
      expect(f1 == f3, isFalse);
    });
  });
}
