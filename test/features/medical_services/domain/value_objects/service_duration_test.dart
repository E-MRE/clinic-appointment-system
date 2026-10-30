import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ServiceDuration', () {
    test('accepts valid range and rejects values outside bounds', () {
      expect(ServiceDuration(5).minutes, 5);
      expect(ServiceDuration(240).minutes, 240);

      final invalidMinutes = <int>[0, 1, 4, 241];
      for (final minutes in invalidMinutes) {
        expect(
          () => ServiceDuration(minutes),
          throwsA(
            isA<InstitutionException>().having(
              (error) => error.code,
              'code',
              InstitutionErrorCode.invalidDuration,
            ),
          ),
          reason: 'Expected $minutes to be rejected',
        );
      }
    });

    test('parse accepts valid strings and rejects non-integer formats', () {
      expect(ServiceDuration.parse('20').minutes, 20);
      expect(ServiceDuration.parse(' 20 ').minutes, 20);

      final invalidInputs = <String>['2.5', 'x', ''];
      for (final input in invalidInputs) {
        expect(
          () => ServiceDuration.parse(input),
          throwsA(
            isA<InstitutionException>().having(
              (error) => error.code,
              'code',
              InstitutionErrorCode.invalidDuration,
            ),
          ),
          reason: 'Expected "$input" to be rejected',
        );
      }
    });

    test('equality and hashCode compare duration in minutes', () {
      final d1 = ServiceDuration(30);
      final d2 = ServiceDuration.parse(' 30 ');
      final d3 = ServiceDuration(45);

      expect(d1, d2);
      expect(d1.hashCode, d2.hashCode);
      expect(d1 == d3, isFalse);
    });
  });
}
