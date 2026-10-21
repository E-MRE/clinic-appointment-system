import 'package:clinic_appointment_system/core/constants/validation_constants.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/auth/presentation/mixins/auth_validation_mixin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final validator = _Validator();

  test('model fields preserve raw input without validation', () {
    const credentials = AuthCredentials(
      email: ' not an email ',
      password: ' a ',
    );
    expect(credentials.email, ' not an email ');
    expect(credentials.password, ' a ');
  });

  test('valid email and existing short passwords succeed', () {
    expect(validator.validateEmail(' Patient@example.com ').isSuccess, isTrue);
    expect(validator.validatePassword(' a ').isSuccess, isTrue);
  });

  testWidgets('malformed emails return translated error messages', (
    tester,
  ) async {
    await _loadTranslations(tester);
    for (final email in [
      '',
      'patient',
      '@example.com',
      'a@',
      'a b@example.com',
    ]) {
      final result = validator.validateEmail(email);
      expect(result.isSuccess, isFalse);
      expect(result.message, 'Geçerli bir e-posta adresi girin.');
      expect(result.message, LocaleKeys.validation_invalidEmail.translate());
    }
  });

  testWidgets('missing password returns a translated error', (tester) async {
    await _loadTranslations(tester);
    final result = validator.validatePassword('');
    expect(result.isSuccess, isFalse);
    expect(result.message, 'Şifrenizi girin.');
  });

  testWidgets('shared password minimum is interpolated into the translation', (
    tester,
  ) async {
    await _loadTranslations(tester);
    const minimum = ValidationConstants.minimumPasswordLength;
    final shortPassword = 'a' * (minimum - 1);
    final result = validator.validatePassword(shortPassword, isSignUp: true);
    expect(result.isSuccess, isFalse);
    expect(result.message, 'Şifreniz en az $minimum karakter olmalıdır.');
    expect(
      validator.validatePassword('a' * minimum, isSignUp: true).isSuccess,
      isTrue,
    );
    expect(
      validator.validatePassword(' abcd ', isSignUp: true).isSuccess,
      isTrue,
    );
  });

  testWidgets('credential validation returns the first localized failure', (
    tester,
  ) async {
    await _loadTranslations(tester);
    expect(
      validator
          .validateCredentials(
            const AuthCredentials(email: 'invalid', password: ''),
          )
          .message,
      LocaleKeys.validation_invalidEmail.translate(),
    );
    expect(
      validator
          .validateCredentials(
            const AuthCredentials(email: 'a@example.com', password: ''),
          )
          .message,
      LocaleKeys.validation_passwordRequired.translate(),
    );
    expect(
      validator
          .validateCredentials(
            const AuthCredentials(email: 'a@example.com', password: '12345'),
            isSignUp: true,
          )
          .isSuccess,
      isFalse,
    );
    expect(
      validator
          .validateCredentials(
            const AuthCredentials(email: 'a@example.com', password: 'secret'),
            isSignUp: true,
          )
          .isSuccess,
      isTrue,
    );
  });
}

final class _Validator with AuthValidationMixin {}

Future<void> _loadTranslations(WidgetTester tester) async {
  await tester.pumpWidget(
    LocalizationWrapper(
      child: Builder(
        builder: (context) => MaterialApp(
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          home: const SizedBox(),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
