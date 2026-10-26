import 'dart:async';

import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/app_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../support/auth_repository_doubles.dart';
import '../../../../support/user_repository_double.dart';

void main() {
  late MockAuthRepository repository;
  late StreamController<DataResult<AuthSession>> controller;
  late AuthCubit cubit;
  late TestUserRepository users;
  const session = AuthSession(
    userId: 'patient-1',
    email: 'patient@example.com',
    isEmailVerified: true,
  );

  setUp(() {
    repository = MockAuthRepository();
    controller = StreamController<DataResult<AuthSession>>();
    when(
      () => repository.authStateChanges(),
    ).thenAnswer((_) => controller.stream);
    users = TestUserRepository();
    cubit = AuthCubit(repository, users);
  });
  tearDown(() async {
    await cubit.close();
    await controller.close();
  });

  test('waits in loading until the restored session is received', () {
    expect(cubit.state, isA<AuthLoading>());
    verify(() => repository.authStateChanges()).called(1);
  });

  test(
    'a restored session authenticates without another sign-in request',
    () async {
      final expectation = expectLater(
        cubit.stream,
        emits(
          isA<AuthSignedIn>()
              .having((s) => s.session, 'session', same(session))
              .having((s) => s.user, 'profile', isA<Patient>()),
        ),
      );
      controller.add(const DataResult.success(data: session));
      await expectation;
      verify(() => repository.authStateChanges()).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test('missing profile emits a coded failure and can sign out', () async {
    users.profileStream = Stream.error(
      const UserException(UserErrorCode.profileMissing),
    );
    when(
      () => repository.signOut(),
    ).thenAnswer((_) async => const Result.success());
    final expectation = expectLater(
      cubit.stream,
      emits(
        isA<AuthProfileFailure>().having(
          (s) => s.errorCode,
          'code',
          UserErrorCode.profileMissing,
        ),
      ),
    );
    controller.add(const DataResult.success(data: session));
    await expectation;
    await cubit.signOut();
    verify(() => repository.signOut()).called(1);
  });

  test('live profile recovers from missing and sign out cancels it', () async {
    final profiles = StreamController<DataResult<User>>();
    users.profileStream = profiles.stream;
    controller.add(const DataResult.success(data: session));
    await Future<void>.delayed(Duration.zero);
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<AuthProfileFailure>().having(
          (s) => s.errorCode,
          'code',
          UserErrorCode.profileMissing,
        ),
        isA<AuthSignedIn>(),
        isA<AuthSignedOut>(),
      ]),
    );
    profiles.addError(const UserException(UserErrorCode.profileMissing));
    profiles.add(
      const DataResult.success(
        data: Patient(
          id: 'patient-1',
          fullName: 'Elif',
          email: 'a@example.com',
        ),
      ),
    );
    await Future<void>.delayed(Duration.zero);
    controller.add(const DataResult.success(data: null));
    await expectation;
    expect(profiles.hasListener, isFalse);
    await profiles.close();
  });

  test('invalid profile emits its typed failure', () async {
    users.profileStream = Stream.error(
      const UserException(UserErrorCode.invalidProfile),
    );
    final expectation = expectLater(
      cubit.stream,
      emits(
        isA<AuthProfileFailure>().having(
          (s) => s.errorCode,
          'code',
          UserErrorCode.invalidProfile,
        ),
      ),
    );
    controller.add(const DataResult.success(data: session));
    await expectation;
  });

  test('successful null session means unauthenticated', () async {
    final expectation = expectLater(cubit.stream, emits(isA<AuthSignedOut>()));
    controller.add(const DataResult.success(data: null));
    await expectation;
  });

  test('subsequent sign-in and sign-out events update session state', () async {
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<AuthSignedOut>(),
        isA<AuthSignedIn>(),
        isA<AuthSignedOut>(),
      ]),
    );
    controller.add(const DataResult.success(data: null));
    controller.add(const DataResult.success(data: session));
    await Future<void>.delayed(Duration.zero);
    controller.add(const DataResult.success(data: null));
    await expectation;
  });

  test(
    'auth exception code reaches failure state and later events recover',
    () async {
      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<AuthFailure>().having(
            (s) => s.errorCode,
            'errorCode',
            AuthErrorCode.networkRequestFailed,
          ),
          isA<AuthSignedIn>(),
        ]),
      );
      controller.addError(
        const AuthException(AuthErrorCode.networkRequestFailed),
      );
      controller.add(const DataResult.success(data: session));
      await expectation;
    },
  );

  test('synchronous subscription errors also expose their auth code', () async {
    await cubit.close();
    when(
      () => repository.authStateChanges(),
    ).thenThrow(const AuthException(AuthErrorCode.userDisabled));
    cubit = AuthCubit(repository, users);
    expect(
      cubit.state,
      isA<AuthFailure>().having(
        (s) => s.errorCode,
        'errorCode',
        AuthErrorCode.userDisabled,
      ),
    );
  });

  test('unexpected exceptions use the fallback code', () async {
    final expectation = expectLater(
      cubit.stream,
      emits(
        isA<AuthFailure>().having(
          (s) => s.errorCode,
          'errorCode',
          AuthErrorCode.unexpected,
        ),
      ),
    );
    controller.addError(const UnexpectedException(message: 'Internal detail'));
    await expectation;
  });

  test('an error result cannot be mistaken for a signed-out session', () async {
    final expectation = expectLater(
      cubit.stream,
      emits(
        isA<AuthFailure>().having(
          (s) => s.errorCode,
          'errorCode',
          AuthErrorCode.unexpected,
        ),
      ),
    );
    controller.add(const DataResult.error(message: 'Operation failed'));
    await expectation;
  });

  test(
    'retry cancels the previous subscription before observing again',
    () async {
      final replacement = StreamController<DataResult<AuthSession>>();
      when(
        () => repository.authStateChanges(),
      ).thenAnswer((_) => replacement.stream);
      await cubit.retry();
      expect(controller.hasListener, isFalse);
      expect(replacement.hasListener, isTrue);
      expect(cubit.state, isA<AuthLoading>());
      final expectation = expectLater(cubit.stream, emits(isA<AuthSignedIn>()));
      replacement.add(const DataResult.success(data: session));
      await expectation;
      await cubit.close();
      await replacement.close();
    },
  );

  test(
    'concurrent retries establish only one replacement subscription',
    () async {
      await cubit.close();
      await controller.close();
      final cancelled = Completer<void>();
      controller = StreamController<DataResult<AuthSession>>(
        onCancel: () => cancelled.future,
      );
      when(
        () => repository.authStateChanges(),
      ).thenAnswer((_) => controller.stream);
      cubit = AuthCubit(repository, users);
      final replacement = StreamController<DataResult<AuthSession>>();
      when(
        () => repository.authStateChanges(),
      ).thenAnswer((_) => replacement.stream);
      clearInteractions(repository);
      final first = cubit.retry();
      final second = cubit.retry();
      cancelled.complete();
      await Future.wait([first, second]);
      verify(() => repository.authStateChanges()).called(1);
      expect(cubit.state, isA<AuthLoading>());
      expect(replacement.hasListener, isTrue);
      await cubit.close();
      await replacement.close();
    },
  );

  test('close releases the session subscription', () async {
    expect(controller.hasListener, isTrue);
    await cubit.close();
    expect(controller.hasListener, isFalse);
    expect(cubit.isClosed, isTrue);
    final state = cubit.state;
    await cubit.retry();
    expect(cubit.state, same(state));
  });

  test('closing during retry does not start a new subscription', () async {
    await cubit.close();
    await controller.close();
    final cancelled = Completer<void>();
    controller = StreamController<DataResult<AuthSession>>(
      onCancel: () => cancelled.future,
    );
    when(
      () => repository.authStateChanges(),
    ).thenAnswer((_) => controller.stream);
    cubit = AuthCubit(repository, users);
    clearInteractions(repository);
    final retry = cubit.retry();
    final close = cubit.close();
    cancelled.complete();
    await Future.wait([retry, close]);
    verifyNever(() => repository.authStateChanges());
    expect(cubit.isClosed, isTrue);
  });
}
