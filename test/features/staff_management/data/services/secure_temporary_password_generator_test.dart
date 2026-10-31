import 'dart:math';

import 'package:clinic_appointment_system/features/staff_management/data/services/secure_temporary_password_generator.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/services/temporary_password_generator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../domain/doubles/auth_validation_probe.dart';
import '../../domain/doubles/fixed_temporary_password_generator.dart';

void main() {
  test('seeded passwords always meet format, alphabet and auth rules', () {
    final AuthValidationProbe validation = AuthValidationProbe();
    final RegExp format = RegExp(
      r'^[A-HJ-NP-Za-km-np-z2-9]{3}-[A-HJ-NP-Za-km-np-z2-9]{4}-[A-HJ-NP-Za-km-np-z2-9]{3}$',
    );
    for (int seed = 0; seed < 100; seed++) {
      final TemporaryPasswordGenerator generator =
          SecureTemporaryPasswordGenerator(Random(seed));
      for (int sample = 0; sample < 20; sample++) {
        final String password = generator.generate();
        expect(format.hasMatch(password), isTrue, reason: password);
        expect(RegExp('[0Oo1lI]').hasMatch(password), isFalse);
        expect(RegExp('[A-Z]').hasMatch(password), isTrue);
        expect(RegExp('[a-z]').hasMatch(password), isTrue);
        expect(RegExp('[2-9]').hasMatch(password), isTrue);
        expect(validation.passwordError(password, isSignUp: true), isNull);
      }
    }
  });

  test('uses the injected source for reproducible sequences', () {
    final TemporaryPasswordGenerator first = SecureTemporaryPasswordGenerator(
      Random(42),
    );
    final TemporaryPasswordGenerator second = SecureTemporaryPasswordGenerator(
      Random(42),
    );
    final Set<String> seen = {};
    for (int sample = 0; sample < 100; sample++) {
      final String password = first.generate();
      expect(password, second.generate());
      seen.add(password);
    }
    expect(seen.length, 100);
  });

  test('fixed generator supports deterministic registration input', () {
    const TemporaryPasswordGenerator generator =
        FixedTemporaryPasswordGenerator();
    expect(generator.generate(), 'Kx7-mP2q-9Tz');
    expect(
      AuthValidationProbe().passwordError(generator.generate(), isSignUp: true),
      isNull,
    );
  });
}
