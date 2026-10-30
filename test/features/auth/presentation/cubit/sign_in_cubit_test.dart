import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/auth_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_state.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../support/auth_repository_doubles.dart';

void main() {
  late MockAuthRepository repository;
  late SignInCubit cubit;
  const credentials = AuthCredentials(
    email: ' patient@example.com ',
    password: ' a ',
  );
  const session = AuthSession(
    userId: 'patient-1',
    email: 'patient@example.com',
    isEmailVerified: false,
  );
  setUp(() {
    repository = MockAuthRepository();
    cubit = SignInCubit(SignInUseCase(repository));
  });
  tearDown(() => cubit.close());

  test(
    'sign in accepts existing short passwords and preserves the input',
    () async {
      when(
        () => repository.signIn(credentials),
      ).thenAnswer((_) async => const DataResult.success(data: session));
      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([isA<AuthRequestLoading>(), isA<AuthRequestSuccess>()]),
      );
      await cubit.signIn(credentials);
      await expectation;
      verify(() => repository.signIn(credentials)).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test('invalid email reports its code without a request', () async {
    await cubit.signIn(
      const AuthCredentials(email: 'invalid', password: 'secret'),
    );
    expect(
      cubit.state,
      isA<AuthRequestFailure>().having(
        (s) => s.errorCode,
        'errorCode',
        AuthErrorCode.invalidEmail,
      ),
    );
    verifyZeroInteractions(repository);
  });

  test('missing password is validated before sign in', () async {
    await cubit.signIn(
      const AuthCredentials(email: 'a@example.com', password: ''),
    );
    expect(
      cubit.state,
      isA<AuthRequestFailure>().having(
        (s) => s.errorCode,
        'errorCode',
        AuthErrorCode.missingPassword,
      ),
    );
    verifyZeroInteractions(repository);
  });

  test('authentication failure exposes its code for the screen', () async {
    when(
      () => repository.signIn(credentials),
    ).thenThrow(const AuthException(AuthErrorCode.invalidCredentials));
    await cubit.signIn(credentials);
    expect(
      cubit.state,
      isA<AuthRequestFailure>().having(
        (s) => s.errorCode,
        'errorCode',
        AuthErrorCode.invalidCredentials,
      ),
    );
  });
}
