import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/app_exception.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_state.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../support/auth_repository_doubles.dart';
import '../../../../support/localization_test_app.dart';

void main() {
  late MockAuthRepository repository;
  late PasswordResetCubit cubit;
  const email = ' patient@example.com ';
  setUp(() {
    repository = MockAuthRepository();
    cubit = PasswordResetCubit(repository);
  });
  tearDown(() => cubit.close());

  test('valid email requests reset without other auth operations', () async {
    when(
      () => repository.sendPasswordResetEmail(email),
    ).thenAnswer((_) async => const Result.success());
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([isA<AuthRequestLoading>(), isA<AuthRequestSuccess>()]),
    );
    await cubit.sendPasswordResetEmail(email);
    await expectation;
    verify(() => repository.sendPasswordResetEmail(email)).called(1);
    verifyNoMoreInteractions(repository);
  });

  testWidgets(
    'invalid emails return a localized message without requesting reset',
    (tester) async {
      await loadTestTranslations(tester);
      await cubit.sendPasswordResetEmail('invalid');
      expect(
        cubit.state,
        isA<AuthRequestFailure>().having(
          (s) => s.message,
          'message',
          LocaleKeys.validation_invalidEmail.translate(),
        ),
      );
      verifyZeroInteractions(repository);
    },
  );

  test('rate limiting exposes its authentication error code', () async {
    when(
      () => repository.sendPasswordResetEmail(email),
    ).thenThrow(const AuthException(AuthErrorCode.tooManyRequests));
    await cubit.sendPasswordResetEmail(email);
    expect(
      cubit.state,
      isA<AuthRequestFailure>().having(
        (s) => s.errorCode,
        'errorCode',
        AuthErrorCode.tooManyRequests,
      ),
    );
  });
}
