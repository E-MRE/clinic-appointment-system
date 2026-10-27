import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/app_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_registration.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/register_patient_use_case.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../support/auth_repository_doubles.dart';
import '../../../../support/user_repository_double.dart';

void main() {
  late MockAuthRepository repository;
  late TestUserRepository users;
  late RegisterPatientUseCase registerPatient;
  const registration = AuthRegistration(
    fullName: '  Elif Kaya  ',
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
    registerPatient = RegisterPatientUseCase(repository, users);
  });

  test('creates the account, then its trimmed patient profile', () async {
    when(
      () => repository.signUp(registration),
    ).thenAnswer((_) async => const DataResult.success(data: session));
    final result = await registerPatient(registration);
    expect(result.data, same(session));
    expect(users.created?.id, session.userId);
    expect(users.created?.fullName, 'Elif Kaya');
    expect(users.created?.email, session.email);
  });

  test('an unsuccessful sign-up returns without a profile', () async {
    const failure = DataResult<AuthSession>.error(message: 'failed');
    when(
      () => repository.signUp(registration),
    ).thenAnswer((_) async => failure);
    expect(await registerPatient(registration), same(failure));
    expect(users.created, isNull);
  });

  test('an authentication failure propagates without a profile', () async {
    when(
      () => repository.signUp(registration),
    ).thenThrow(const AuthException(AuthErrorCode.emailAlreadyInUse));
    await expectLater(
      registerPatient(registration),
      throwsA(
        isA<AuthException>().having(
          (e) => e.code,
          'code',
          AuthErrorCode.emailAlreadyInUse,
        ),
      ),
    );
    expect(users.created, isNull);
  });

  test('a profile failure reports that the account exists', () async {
    users.createError = const UserException(UserErrorCode.unavailable);
    when(
      () => repository.signUp(registration),
    ).thenAnswer((_) async => const DataResult.success(data: session));
    await expectLater(
      registerPatient(registration),
      throwsA(
        isA<AuthException>().having(
          (e) => e.code,
          'code',
          AuthErrorCode.profileCreationFailed,
        ),
      ),
    );
  });
}
