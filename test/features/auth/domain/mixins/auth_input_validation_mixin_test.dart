import 'package:clinic_appointment_system/core/constants/validation_constants.dart';
import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/auth_exception.dart';
import 'package:clinic_appointment_system/features/auth/domain/mixins/auth_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_registration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final validator = _Validator();
  const minimum = ValidationConstants.minimumPasswordLength;

  test('model fields preserve raw input without validation', () {
    const credentials = AuthCredentials(
      email: ' not an email ',
      password: ' a ',
    );
    expect(credentials.email, ' not an email ');
    expect(credentials.password, ' a ');
  });

  test('valid email and existing short passwords pass', () {
    expect(validator.emailError(' Patient@example.com '), isNull);
    expect(validator.passwordError(' a '), isNull);
  });

  test('malformed emails report invalidEmail', () {
    for (final email in [
      '',
      'patient',
      '@example.com',
      'a@',
      'a b@example.com',
    ]) {
      expect(validator.emailError(email), AuthErrorCode.invalidEmail);
    }
  });

  test('empty passwords report missingPassword', () {
    expect(validator.passwordError(''), AuthErrorCode.missingPassword);
    expect(
      validator.passwordError('', isSignUp: true),
      AuthErrorCode.missingPassword,
    );
  });

  test('sign-up passwords need the shared minimum length', () {
    expect(
      validator.passwordError('a' * (minimum - 1), isSignUp: true),
      AuthErrorCode.passwordTooShort,
    );
    expect(validator.passwordError('a' * minimum, isSignUp: true), isNull);
    expect(validator.passwordError(' abcdef ', isSignUp: true), isNull);
  });

  test('blank names report fullNameRequired', () {
    expect(validator.fullNameError('   '), AuthErrorCode.fullNameRequired);
    expect(validator.fullNameError('Elif'), isNull);
  });

  test('credentials check the email before the password', () {
    expect(
      validator.credentialsError(
        const AuthCredentials(email: 'invalid', password: ''),
      ),
      AuthErrorCode.invalidEmail,
    );
    expect(
      validator.credentialsError(
        const AuthCredentials(email: 'a@example.com', password: ''),
      ),
      AuthErrorCode.missingPassword,
    );
    expect(
      validator.credentialsError(
        const AuthCredentials(email: 'a@example.com', password: 'short'),
        isSignUp: true,
      ),
      AuthErrorCode.passwordTooShort,
    );
  });

  test('registration checks the name before the credentials', () {
    expect(
      validator.registrationError(
        const AuthRegistration(fullName: ' ', email: 'invalid', password: ''),
      ),
      AuthErrorCode.fullNameRequired,
    );
    expect(
      validator.registrationError(
        const AuthRegistration(
          fullName: 'Elif',
          email: 'a@example.com',
          password: 'short',
        ),
      ),
      AuthErrorCode.passwordTooShort,
    );
  });

  test('ensureValid throws only for a failed check', () {
    expect(() => validator.ensureValid(null), returnsNormally);
    expect(
      () => validator.ensureValid(AuthErrorCode.invalidEmail),
      throwsA(
        isA<AuthException>().having(
          (e) => e.code,
          'code',
          AuthErrorCode.invalidEmail,
        ),
      ),
    );
  });
}

final class _Validator with AuthInputValidationMixin {}
