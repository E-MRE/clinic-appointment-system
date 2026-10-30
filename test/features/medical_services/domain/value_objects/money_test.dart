import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Money', () {
    test(
      'minorUnits constructor accepts valid bounds and rejects out-of-range values',
      () {
        expect(Money.minorUnits(100).minorUnits, 100);
        expect(Money.minorUnits(100).lira, 1.0);
        expect(Money.minorUnits(10000000).minorUnits, 10000000);
        expect(Money.minorUnits(10000000).lira, 100000.0);

        expect(
          () => Money.minorUnits(0),
          throwsA(
            isA<InstitutionException>().having(
              (error) => error.code,
              'code',
              InstitutionErrorCode.invalidFee,
            ),
          ),
        );
        expect(
          () => Money.minorUnits(99),
          throwsA(
            isA<InstitutionException>().having(
              (error) => error.code,
              'code',
              InstitutionErrorCode.invalidFee,
            ),
          ),
        );
        expect(
          () => Money.minorUnits(10000001),
          throwsA(
            isA<InstitutionException>().having(
              (error) => error.code,
              'code',
              InstitutionErrorCode.invalidFee,
            ),
          ),
        );
      },
    );

    test('parseLira parses valid integer and decimal representations', () {
      expect(Money.parseLira('1').minorUnits, 100);
      expect(Money.parseLira('100000').minorUnits, 10000000);
      expect(Money.parseLira('100000,00').minorUnits, 10000000);
      expect(Money.parseLira('850,5').minorUnits, 85050);
      expect(Money.parseLira('850.50').minorUnits, 85050);
      expect(Money.parseLira(' 1200 ').minorUnits, 120000);
    });

    test('parseLira rejects invalid formats and amounts outside bounds', () {
      final invalidInputs = <String>[
        '100000,01',
        '0',
        '0,99',
        '1.200',
        '12,345',
        '-5',
        'abc',
        '',
        '  ',
        '1,2,3',
      ];

      for (final input in invalidInputs) {
        expect(
          () => Money.parseLira(input),
          throwsA(
            isA<InstitutionException>().having(
              (error) => error.code,
              'code',
              InstitutionErrorCode.invalidFee,
            ),
          ),
          reason: 'Expected "$input" to be rejected as invalidFee',
        );
      }
    });

    test('equality and hashCode compare minor-unit amounts', () {
      final m1 = Money.minorUnits(85050);
      final m2 = Money.parseLira('850,5');
      final m3 = Money.minorUnits(100);

      expect(m1, m2);
      expect(m1.hashCode, m2.hashCode);
      expect(m1 == m3, isFalse);
    });
  });

  test('parseLira rejects lira that would overflow the minor-unit product', () {
    expect(
      () => Money.parseLira('92233720368547758'),
      throwsA(
        isA<InstitutionException>().having(
          (error) => error.code,
          'code',
          InstitutionErrorCode.invalidFee,
        ),
      ),
    );
  });
}
