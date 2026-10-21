import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('base exception implements Exception and preserves its message', () {
    const error = AppException(message: 'Diagnostic detail');
    expect(error, isA<Exception>());
    expect(error.message, 'Diagnostic detail');
    expect(error.toString(), 'AppException: Diagnostic detail');
    expect(const AppException().message, isEmpty);
  });

  test('auth and unexpected exceptions share the application base type', () {
    const errors = <AppException>[
      AuthException(AuthErrorCode.invalidCredentials),
      UnexpectedException(),
    ];
    for (final error in errors) {
      expect(error, isA<Exception>());
      expect(error.message, isEmpty);
    }
    expect(
      errors.first,
      isA<AuthException>().having(
        (e) => e.code,
        'code',
        AuthErrorCode.invalidCredentials,
      ),
    );
  });
}
