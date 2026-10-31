import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/auth_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/features/auth/data/mappers/firebase_auth_exception_mapper.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/staff_management/data/services/firebase_staff_account_provisioner.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../support/firebase_auth_doubles.dart';
import '../doubles/fake_secondary_auth_provider.dart';

// FirebaseSecondaryAuthProvider is a thin SDK binding with global app state and
// platform initialization. Real named-app/session isolation and initialization
// concurrency require a platform integration test; unit tests inject this seam.
void main() {
  late MockFirebaseAuth secondaryAuth;
  late MockFirebaseAuth primaryAuth;
  late MockFirebaseUser user;
  late MockUserCredential credential;
  late FakeSecondaryAuthProvider provider;
  late FirebaseStaffAccountProvisioner provisioner;
  const AuthCredentials credentials = AuthCredentials(
    email: ' staff@example.com ',
    password: ' unchanged ',
  );

  setUp(() {
    secondaryAuth = MockFirebaseAuth();
    primaryAuth = MockFirebaseAuth();
    user = MockFirebaseUser();
    credential = MockUserCredential();
    provider = FakeSecondaryAuthProvider(secondaryAuth);
    provisioner = FirebaseStaffAccountProvisioner(
      provider,
      const FirebaseAuthExceptionMapper(),
    );
    when(() => user.uid).thenReturn('staff-uid');
    when(() => credential.user).thenReturn(user);
    when(
      () => secondaryAuth.createUserWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => credential);
    when(() => secondaryAuth.signOut()).thenAnswer((_) async {});
    when(() => user.delete()).thenAnswer((_) async {});
  });

  tearDown(() {
    verifyZeroInteractions(primaryAuth);
  });

  test(
    'completes the profile with uid, returns success and signs out only secondary auth',
    () async {
      String? completedUid;
      final DataResult<String> result = await provisioner.provision(
        credentials,
        completeProfile: (String uid) async {
          completedUid = uid;
        },
      );
      expect(result.isSuccess, isTrue);
      expect(result.data, 'staff-uid');
      expect(completedUid, 'staff-uid');
      expect(provider.calls, 1);
      verify(
        () => secondaryAuth.createUserWithEmailAndPassword(
          email: 'staff@example.com',
          password: ' unchanged ',
        ),
      ).called(1);
      verify(() => secondaryAuth.signOut()).called(1);
      verifyNever(() => user.delete());
    },
  );
  test(
    'maps email-already-in-use and signs out without completing a profile',
    () async {
      when(
        () => secondaryAuth.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));
      bool completed = false;
      await expectLater(
        provisioner.provision(
          credentials,
          completeProfile: (_) async {
            completed = true;
          },
        ),
        throwsA(
          isA<AuthException>().having(
            (AuthException error) => error.code,
            'code',
            AuthErrorCode.emailAlreadyInUse,
          ),
        ),
      );
      expect(completed, isFalse);
      verifyNever(() => user.delete());
      verify(() => secondaryAuth.signOut()).called(1);
    },
  );

  test(
    'profile failure deletes account and preserves the exact error and stack',
    () async {
      const UserException original = UserException(UserErrorCode.unavailable);
      final StackTrace originalStack = StackTrace.fromString(
        'profile-write-stack',
      );
      try {
        await provisioner.provision(
          credentials,
          completeProfile: (_) => Future<void>.error(original, originalStack),
        );
        fail('Expected profile failure');
      } on UserException catch (error, stackTrace) {
        expect(error, same(original));
        expect(stackTrace.toString(), originalStack.toString());
      }
      verify(() => user.delete()).called(1);
      verify(() => secondaryAuth.signOut()).called(1);
    },
  );

  test('failed account deletion reports orphanAccount and signs out', () async {
    when(
      () => user.delete(),
    ).thenThrow(FirebaseAuthException(code: 'network-request-failed'));
    await expectLater(
      provisioner.provision(
        credentials,
        completeProfile: (_) async {
          throw const UserException(UserErrorCode.unavailable);
        },
      ),
      throwsA(
        isA<UserException>().having(
          (UserException error) => error.code,
          'code',
          UserErrorCode.orphanAccount,
        ),
      ),
    );
    verify(() => secondaryAuth.signOut()).called(1);
  });

  test('signOut failure preserves successful provisioning', () async {
    when(
      () => secondaryAuth.signOut(),
    ).thenThrow(FirebaseAuthException(code: 'network-request-failed'));
    final DataResult<String> result = await provisioner.provision(
      credentials,
      completeProfile: (_) async {},
    );
    expect(result.isSuccess, isTrue);
    expect(result.data, 'staff-uid');
    verify(() => secondaryAuth.signOut()).called(1);
  });

  test(
    'null credential user is unexpected, signs out and skips the profile',
    () async {
      when(() => credential.user).thenReturn(null);
      bool completed = false;
      await expectLater(
        provisioner.provision(
          credentials,
          completeProfile: (_) async {
            completed = true;
          },
        ),
        throwsA(
          isA<AuthException>().having(
            (AuthException error) => error.code,
            'code',
            AuthErrorCode.unexpected,
          ),
        ),
      );
      expect(completed, isFalse);
      verifyNever(() => user.delete());
      verify(() => secondaryAuth.signOut()).called(1);
    },
  );

  test('cleanup signOut failure cannot mask the profile error', () async {
    const UserException original = UserException(UserErrorCode.unavailable);
    when(() => secondaryAuth.signOut()).thenThrow(StateError('signOut failed'));
    await expectLater(
      provisioner.provision(
        credentials,
        completeProfile: (_) async {
          throw original;
        },
      ),
      throwsA(same(original)),
    );
    verify(() => user.delete()).called(1);
    verify(() => secondaryAuth.signOut()).called(1);
  });

  test(
    'non-Exception profile error is rolled back and rethrown unchanged',
    () async {
      final StateError original = StateError('profile failed');
      await expectLater(
        provisioner.provision(
          credentials,
          completeProfile: (_) async {
            throw original;
          },
        ),
        throwsA(same(original)),
      );
      verify(() => user.delete()).called(1);
      verify(() => secondaryAuth.signOut()).called(1);
    },
  );

  test(
    'secondary provider initialization failure maps to AuthException',
    () async {
      provider.error = FirebaseAuthException(code: 'network-request-failed');
      await expectLater(
        provisioner.provision(
          credentials,
          completeProfile: (_) async {
            fail('No account created');
          },
        ),
        throwsA(
          isA<AuthException>().having(
            (AuthException error) => error.code,
            'code',
            AuthErrorCode.networkRequestFailed,
          ),
        ),
      );
      verifyZeroInteractions(secondaryAuth);
    },
  );
}
