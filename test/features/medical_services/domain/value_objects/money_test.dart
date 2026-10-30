import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Money', () {
    test(
      'kurus factory accepts valid bounds and rejects out-of-range values',
      () {
        expect(Money.kurus(100).kurus, 100);
        expect(Money.kurus(100).lira, 1.0);
        expect(Money.kurus(10000000).kurus, 10000000);
        expect(Money.kurus(10000000).lira, 100000.0);

        expect(
          () => Money.kurus(0),
          throwsA(
            isA<InstitutionException>().having(
              (error) => error.code,
              'code',
              InstitutionErrorCode.invalidFee,
            ),
          ),
        );
        expect(
          () => Money.kurus(99),
          throwsA(
            isA<InstitutionException>().having(
              (error) => error.code,
              'code',
              InstitutionErrorCode.invalidFee,
            ),
          ),
        );
        expect(
          () => Money.kurus(10000001),
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
      expect(Money.parseLira('1').kurus, 100);
      expect(Money.parseLira('100000').kurus, 10000000);
      expect(Money.parseLira('100000,00').kurus, 10000000);
      expect(Money.parseLira('850,5').kurus, 85050);
      expect(Money.parseLira('850.50').kurus, 85050);
      expect(Money.parseLira(' 1200 ').kurus, 120000);
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

    test('equality and hashCode compare kurus amounts', () {
      final m1 = Money.kurus(85050);
      final m2 = Money.parseLira('850,5');
      final m3 = Money.kurus(100);

      expect(m1, m2);
      expect(m1.hashCode, m2.hashCode);
      expect(m1 == m3, isFalse);
    });
  });

  test('parseLira rejects lira that would overflow the kuruş product', () {
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
