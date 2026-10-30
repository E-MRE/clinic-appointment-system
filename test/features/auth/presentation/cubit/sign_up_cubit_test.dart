import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/auth_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_registration.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/register_patient_use_case.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_state.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../support/auth_repository_doubles.dart';
import '../../../../support/user_repository_double.dart';

void main() {
  late MockAuthRepository repository;
  late SignUpCubit cubit;
  late TestUserRepository users;
  const credentials = AuthRegistration(
    fullName: 'Elif Kaya',
    email: 'patient@example.com',
    password: 'secret12',
  );
  const session = AuthSession(
    userId: 'patient-1',
    email: 'patient@example.com',
    isEmailVerified: false,
  );
  setUp(() {
    repository = MockAuthRepository();
    users = TestUserRepository();
    cubit = SignUpCubit(RegisterPatientUseCase(repository, users));
    clearInteractions(repository);
  });
  tearDown(() async {
    await cubit.close();
  });

  test('valid registration calls only sign up and emits success', () async {
    when(
      () => repository.signUp(credentials),
    ).thenAnswer((_) async => const DataResult.success(data: session));
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([isA<AuthRequestLoading>(), isA<AuthRequestSuccess>()]),
    );
    await cubit.signUp(credentials);
    await expectation;
    verify(() => repository.signUp(credentials)).called(1);
    verifyNoMoreInteractions(repository);
    expect(users.created?.id, session.userId);
    expect(users.created?.fullName, credentials.fullName);
    expect(users.created?.email, session.email);
  });

  test('profile write failure reports that the account exists', () async {
    users.createError = const UserException(UserErrorCode.unavailable);
    when(
      () => repository.signUp(credentials),
    ).thenAnswer((_) async => const DataResult.success(data: session));
    await cubit.signUp(credentials);
    expect(
      cubit.state,
      isA<AuthRequestFailure>().having(
        (s) => s.errorCode,
        'code',
        AuthErrorCode.profileCreationFailed,
      ),
    );
  });

  test('short passwords fail before registration', () async {
    await cubit.signUp(
      const AuthRegistration(
        fullName: 'Elif Kaya',
        email: 'a@example.com',
        password: '12345',
      ),
    );
    expect(
      cubit.state,
      isA<AuthRequestFailure>().having(
        (s) => s.errorCode,
        'errorCode',
        AuthErrorCode.passwordTooShort,
      ),
    );
    verifyZeroInteractions(repository);
  });

  test('invalid emails fail before registration', () async {
    await cubit.signUp(
      const AuthRegistration(
        fullName: 'Elif Kaya',
        email: 'invalid',
        password: 'secret12',
      ),
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

  test('blank names do not reach the repository', () async {
    await cubit.signUp(
      const AuthRegistration(
        fullName: '   ',
        email: 'a@example.com',
        password: 'secret12',
      ),
    );
    expect(
      cubit.state,
      isA<AuthRequestFailure>().having(
        (s) => s.errorCode,
        'errorCode',
        AuthErrorCode.fullNameRequired,
      ),
    );
    verifyZeroInteractions(repository);
  });

  test('existing email failure exposes the authentication code', () async {
    when(
      () => repository.signUp(credentials),
    ).thenThrow(const AuthException(AuthErrorCode.emailAlreadyInUse));
    await cubit.signUp(credentials);
    expect(
      cubit.state,
      isA<AuthRequestFailure>().having(
        (s) => s.errorCode,
        'errorCode',
        AuthErrorCode.emailAlreadyInUse,
      ),
    );
  });
}
