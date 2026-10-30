import 'dart:async';

import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/auth_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/unexpected_exception.dart';
import 'package:clinic_appointment_system/features/auth/data/mappers/firebase_auth_exception_mapper.dart';
import 'package:clinic_appointment_system/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/domain/mappers/auth_exception_mapper.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../support/firebase_auth_doubles.dart';

void main() {
  late MockFirebaseAuth auth;
  late MockFirebaseUser user;
  late MockUserCredential credential;
  late FirebaseAuthRepository repository;
  const credentials = AuthCredentials(
    email: ' patient@example.com ',
    password: ' secret ',
  );

  const registration = AuthRegistration(
    fullName: ' Elif Kaya ',
    email: ' patient@example.com ',
    password: ' secret ',
  );

  setUp(() {
    auth = MockFirebaseAuth();
    user = MockFirebaseUser();
    credential = MockUserCredential();
    repository = FirebaseAuthRepository(
      auth,
      const FirebaseAuthExceptionMapper(),
    );
    when(() => user.uid).thenReturn('patient-1');
    when(() => user.email).thenReturn('patient@example.com');
    when(() => user.emailVerified).thenReturn(false);
    when(() => credential.user).thenReturn(user);
    when(() => user.updateDisplayName(any())).thenAnswer((_) async {});
    when(
      () => auth.signInWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => credential);
    when(
      () => auth.createUserWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => credential);
  });

  test('sign up returns DataResult and normalizes only the email', () async {
    final result = await repository.signUp(registration);
    expect(result.isSuccess, isTrue);
    expect(result.data?.userId, 'patient-1');
    expect(result.data?.email, 'patient@example.com');
    verify(
      () => auth.createUserWithEmailAndPassword(
        email: 'patient@example.com',
        password: ' secret ',
      ),
    ).called(1);
  });

  test('registration saves the trimmed full name', () async {
    await repository.signUp(registration);
    verify(() => user.updateDisplayName('Elif Kaya')).called(1);
  });

  test('profile failure identifies an already created account', () async {
    when(
      () => user.updateDisplayName(any()),
    ).thenThrow(FirebaseAuthException(code: 'network-request-failed'));
    await expectLater(
      repository.signUp(registration),
      throwsA(
        isA<AuthException>().having(
          (e) => e.code,
          'code',
          AuthErrorCode.profileUpdateFailed,
        ),
      ),
    );
    verify(
      () => auth.createUserWithEmailAndPassword(
        email: 'patient@example.com',
        password: ' secret ',
      ),
    ).called(1);
  });

  test('sign in returns a domain session inside DataResult', () async {
    final result = await repository.signIn(credentials);
    expect(result.isSuccess, isTrue);
    expect(result.data?.userId, 'patient-1');
    expect(result.data?.isEmailVerified, isFalse);
    verify(
      () => auth.signInWithEmailAndPassword(
        email: 'patient@example.com',
        password: ' secret ',
      ),
    ).called(1);
  });

  test('sign out returns a successful Result', () async {
    when(() => auth.signOut()).thenAnswer((_) async {});
    expect((await repository.signOut()).isSuccess, isTrue);
    verify(() => auth.signOut()).called(1);
  });

  test('reset returns Result and sends a normalized email', () async {
    when(
      () => auth.sendPasswordResetEmail(email: 'patient@example.com'),
    ).thenAnswer((_) async {});
    expect(
      (await repository.sendPasswordResetEmail(
        ' patient@example.com ',
      )).isSuccess,
      isTrue,
    );
    verify(
      () => auth.sendPasswordResetEmail(email: 'patient@example.com'),
    ).called(1);
  });

  test(
    'session stream distinguishes restored, signed out and signed in',
    () async {
      when(
        () => auth.authStateChanges(),
      ).thenAnswer((_) => Stream<User?>.fromIterable([user, null, user]));
      final Stream<DataResult<AuthSession>> stream = repository
          .authStateChanges();
      final results = await stream.toList();
      expect(results.every((result) => result.isSuccess), isTrue);
      expect(results[0].data?.userId, 'patient-1');
      expect(results[1].data, isNull);
      expect(results[2].data?.userId, 'patient-1');
    },
  );

  test('session keeps a required email and verified status', () async {
    when(() => user.emailVerified).thenReturn(true);
    when(() => auth.authStateChanges()).thenAnswer((_) => Stream.value(user));
    final result = await repository.authStateChanges().first;
    expect(result.data?.email, 'patient@example.com');
    expect(result.data?.isEmailVerified, isTrue);
  });

  for (final email in [null, '', '   ']) {
    test(
      'missing required email throws an application exception: "$email"',
      () async {
        when(() => user.email).thenReturn(email);
        await expectLater(
          repository.signIn(credentials),
          throwsA(
            isA<AuthException>().having(
              (e) => e.code,
              'code',
              AuthErrorCode.unexpected,
            ),
          ),
        );
      },
    );
  }

  test('missing credential user throws an application exception', () async {
    when(() => credential.user).thenReturn(null);
    await expectLater(
      repository.signIn(credentials),
      throwsA(
        isA<AuthException>().having(
          (e) => e.code,
          'code',
          AuthErrorCode.unexpected,
        ),
      ),
    );
  });

  test(
    'every Firebase operation throws a coded application exception',
    () async {
      final error = FirebaseAuthException(
        code: 'network-request-failed',
        message: 'Connection failed',
      );
      when(
        () => auth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(error);
      when(
        () => auth.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(error);
      when(() => auth.signOut()).thenThrow(error);
      when(
        () => auth.sendPasswordResetEmail(email: any(named: 'email')),
      ).thenThrow(error);
      final operations = <Future<Object?> Function()>[
        () => repository.signIn(credentials),
        () => repository.signUp(registration),
        repository.signOut,
        () => repository.sendPasswordResetEmail('a@example.com'),
      ];
      for (final operation in operations) {
        await expectLater(
          operation(),
          throwsA(
            isA<AuthException>()
                .having(
                  (e) => e.code,
                  'code',
                  AuthErrorCode.networkRequestFailed,
                )
                .having((e) => e.message, 'message', 'Connection failed'),
          ),
        );
      }
    },
  );

  test(
    'Firebase error without a message still carries its application code',
    () async {
      when(
        () => auth.signOut(),
      ).thenThrow(FirebaseAuthException(code: 'network-request-failed'));
      await expectLater(
        repository.signOut(),
        throwsA(
          isA<AuthException>().having(
            (e) => e.code,
            'code',
            AuthErrorCode.networkRequestFailed,
          ),
        ),
      );
    },
  );

  test(
    'stream emits coded errors and continues delivering session changes',
    () async {
      final controller = StreamController<User?>();
      when(() => auth.authStateChanges()).thenAnswer((_) => controller.stream);
      final expectation = expectLater(
        repository.authStateChanges(),
        emitsInOrder([
          emitsError(
            isA<AuthException>()
                .having(
                  (e) => e.code,
                  'code',
                  AuthErrorCode.networkRequestFailed,
                )
                .having((e) => e.message, 'message', 'Connection failed'),
          ),
          isA<DataResult<AuthSession>>()
              .having((r) => r.isSuccess, 'isSuccess', true)
              .having((r) => r.data, 'data', isNull),
          isA<DataResult<AuthSession>>().having(
            (r) => r.data?.userId,
            'userId',
            'patient-1',
          ),
          emitsDone,
        ]),
      );
      controller.addError(
        FirebaseAuthException(
          code: 'network-request-failed',
          message: 'Connection failed',
        ),
      );
      controller.add(null);
      controller.add(user);
      await controller.close();
      await expectation;
    },
  );

  test(
    'invalid stream sessions propagate application exceptions for Cubit',
    () async {
      when(() => user.email).thenReturn(null);
      when(() => auth.authStateChanges()).thenAnswer((_) => Stream.value(user));
      await expectLater(
        repository.authStateChanges(),
        emitsInOrder([
          emitsError(
            isA<AuthException>().having(
              (e) => e.code,
              'code',
              AuthErrorCode.unexpected,
            ),
          ),
          emitsDone,
        ]),
      );
    },
  );

  test('subscription cancellation reaches the provider', () async {
    bool cancelled = false;
    final controller = StreamController<User?>(
      onCancel: () => cancelled = true,
    );
    when(() => auth.authStateChanges()).thenAnswer((_) => controller.stream);
    await repository.authStateChanges().listen((_) {}).cancel();
    expect(cancelled, isTrue);
    await controller.close();
  });

  test(
    'stream errors use the mapper supplied through the constructor',
    () async {
      final mapper = _MockAuthExceptionMapper();
      final providerError = FirebaseAuthException(
        code: 'network-request-failed',
      );
      const mappedError = UnexpectedException(message: 'Custom mapping');
      when(() => mapper.map(providerError)).thenReturn(mappedError);
      when(
        () => auth.authStateChanges(),
      ).thenAnswer((_) => Stream<User?>.error(providerError));
      final customRepository = FirebaseAuthRepository(auth, mapper);

      await expectLater(
        customRepository.authStateChanges(),
        emitsInOrder([emitsError(same(mappedError)), emitsDone]),
      );
      verify(() => mapper.map(providerError)).called(1);
    },
  );

  test(
    'Firebase stream setup failure throws a coded application exception',
    () {
      when(() => auth.authStateChanges()).thenThrow(
        FirebaseAuthException(
          code: 'network-request-failed',
          message: 'Connection failed',
        ),
      );
      expect(
        repository.authStateChanges,
        throwsA(
          isA<AuthException>().having(
            (e) => e.code,
            'code',
            AuthErrorCode.networkRequestFailed,
          ),
        ),
      );
    },
  );

  test('provider stack trace is retained when an operation fails', () async {
    final stackTrace = StackTrace.fromString('provider-operation-stack');
    when(() => auth.signOut()).thenAnswer(
      (_) => Future<void>.error(
        FirebaseAuthException(code: 'network-request-failed'),
        stackTrace,
      ),
    );
    try {
      await repository.signOut();
      fail('Expected an AuthException');
    } on AuthException catch (error, actualStack) {
      expect(error.code, AuthErrorCode.networkRequestFailed);
      expect(actualStack.toString(), contains('provider-operation-stack'));
    }
  });

  test(
    'application exceptions remain available for the caller to catch',
    () async {
      const error = UnexpectedException(message: 'Invalid provider response');
      when(() => auth.signOut()).thenThrow(error);
      await expectLater(repository.signOut(), throwsA(same(error)));
    },
  );

  test(
    'unexpected SDK exceptions become application exceptions with their message',
    () async {
      when(() => auth.signOut()).thenThrow(Exception('SDK detail'));
      await expectLater(
        repository.signOut(),
        throwsA(
          isA<AuthException>()
              .having((e) => e.code, 'code', AuthErrorCode.unexpected)
              .having((e) => e.message, 'message', 'Exception: SDK detail'),
        ),
      );
    },
  );
}

class _MockAuthExceptionMapper extends Mock implements AuthExceptionMapper {}
