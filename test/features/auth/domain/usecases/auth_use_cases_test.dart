import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:clinic_appointment_system/core/usecases/no_params.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/send_password_reset_email_use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/watch_session_use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/watch_user_profile_use_case.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/admin.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../support/auth_repository_doubles.dart';
import '../../../../support/user_repository_double.dart';

void main() {
  late MockAuthRepository repository;
  const credentials = AuthCredentials(
    email: 'patient@example.com',
    password: 'secret12',
  );
  const session = DataResult.success(
    data: AuthSession(
      userId: 'patient-1',
      email: 'patient@example.com',
      isEmailVerified: false,
    ),
  );
  setUp(() => repository = MockAuthRepository());

  test('sign in returns the repository session', () async {
    when(() => repository.signIn(credentials)).thenAnswer((_) async => session);
    expect(await SignInUseCase(repository)(credentials), same(session));
  });

  test('password reset requests the email for the address', () async {
    const result = Result.success();
    when(
      () => repository.sendPasswordResetEmail('patient@example.com'),
    ).thenAnswer((_) async => result);
    expect(
      await SendPasswordResetEmailUseCase(repository)('patient@example.com'),
      same(result),
    );
  });

  test('sign out signs out through the repository', () async {
    const result = Result.success();
    when(() => repository.signOut()).thenAnswer((_) async => result);
    expect(await SignOutUseCase(repository)(const NoParams()), same(result));
  });

  test('watch session forwards the session stream', () async {
    when(
      () => repository.authStateChanges(),
    ).thenAnswer((_) => Stream.value(session));
    await expectLater(
      WatchSessionUseCase(repository)(const NoParams()),
      emits(same(session)),
    );
  });

  test('watch user profile forwards the profile stream', () async {
    const profile = DataResult<User>.success(
      data: Admin(id: 'uid', fullName: 'Elif', email: 'e@x.com'),
    );
    final users = TestUserRepository()..getResult = profile;
    await expectLater(
      WatchUserProfileUseCase(users)('uid'),
      emits(same(profile)),
    );
  });
}
