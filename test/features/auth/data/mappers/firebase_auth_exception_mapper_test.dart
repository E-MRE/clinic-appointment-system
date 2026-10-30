import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/auth_exception.dart';
import 'package:clinic_appointment_system/core/errors/unexpected_exception.dart';
import 'package:clinic_appointment_system/features/auth/data/mappers/firebase_auth_exception_mapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const mapper = FirebaseAuthExceptionMapper();
  final codes = {
    'invalid-email': AuthErrorCode.invalidEmail,
    'weak-password': AuthErrorCode.weakPassword,
    'email-already-in-use': AuthErrorCode.emailAlreadyInUse,
    'invalid-credential': AuthErrorCode.invalidCredentials,
    'INVALID_LOGIN_CREDENTIALS': AuthErrorCode.invalidCredentials,
    'wrong-password': AuthErrorCode.invalidCredentials,
    'user-not-found': AuthErrorCode.invalidCredentials,
    'user-disabled': AuthErrorCode.userDisabled,
    'too-many-requests': AuthErrorCode.tooManyRequests,
    'network-request-failed': AuthErrorCode.networkRequestFailed,
    'operation-not-allowed': AuthErrorCode.operationNotAllowed,
  };
  for (final entry in codes.entries) {
    test('maps ${entry.key} and preserves its message', () {
      final result = mapper.map(
        FirebaseAuthException(code: entry.key, message: 'Provider message'),
      );
      expect(
        result,
        isA<AuthException>().having((e) => e.code, 'code', entry.value),
      );
      expect(result.message, 'Provider message');
    });
  }
  test(
    'unknown provider errors preserve their message as unexpected errors',
    () {
      final result = mapper.map(
        FirebaseAuthException(code: 'unknown', message: 'Provider message'),
      );
      expect(
        result,
        isA<AuthException>().having(
          (e) => e.code,
          'code',
          AuthErrorCode.unexpected,
        ),
      );
      expect(result.message, 'Provider message');
    },
  );
  test('existing application exceptions are preserved', () {
    const error = UnexpectedException(message: 'Application detail');
    expect(mapper.map(error), same(error));
  });
}
