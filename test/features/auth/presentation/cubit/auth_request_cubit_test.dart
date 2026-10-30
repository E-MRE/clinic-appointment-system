import 'dart:async';

import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/auth_exception.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:clinic_appointment_system/core/errors/unexpected_exception.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _RequestCubit cubit;
  setUp(() => cubit = _RequestCubit());
  tearDown(() => cubit.close());

  test('new requests start in initial state', () {
    expect(cubit.state, isA<AuthRequestInitial>());
  });

  test('valid requests emit loading then success', () async {
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([isA<AuthRequestLoading>(), isA<AuthRequestSuccess>()]),
    );
    await cubit.submit(request: () async => const Result.success());
    await expectation;
  });

  for (final code in AuthErrorCode.values) {
    test('AuthException $code reaches the failure state', () async {
      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<AuthRequestLoading>(),
          isA<AuthRequestFailure>()
              .having((s) => s.errorCode, 'errorCode', code)
              .having((s) => s.message, 'message', isNull),
        ]),
      );
      await cubit.submit(
        request: () async =>
            throw AuthException(code, message: 'Provider detail'),
      );
      await expectation;
    });
  }

  test('unexpected exceptions produce the fallback code', () async {
    await cubit.submit(
      request: () async =>
          throw const UnexpectedException(message: 'Internal detail'),
    );
    expect(
      cubit.state,
      isA<AuthRequestFailure>()
          .having((s) => s.errorCode, 'errorCode', AuthErrorCode.unexpected)
          .having((s) => s.message, 'message', isNull),
    );
  });

  test('error results preserve their message', () async {
    await cubit.submit(
      request: () async => const Result.error(message: 'Operation failed'),
    );
    expect(
      cubit.state,
      isA<AuthRequestFailure>().having(
        (s) => s.message,
        'message',
        'Operation failed',
      ),
    );
  });

  test('empty error messages use the fallback code', () async {
    await cubit.submit(request: () async => const Result.error());
    expect(
      cubit.state,
      isA<AuthRequestFailure>().having(
        (s) => s.errorCode,
        'errorCode',
        AuthErrorCode.unexpected,
      ),
    );
  });

  test('a pending request ignores duplicate submissions', () async {
    final pending = Completer<Result>();
    final first = cubit.submit(request: () => pending.future);
    expect(cubit.state, isA<AuthRequestLoading>());
    int duplicateCalls = 0;
    await cubit.submit(
      request: () async {
        duplicateCalls++;
        return const Result.success();
      },
    );
    expect(duplicateCalls, 0);
    pending.complete(const Result.success());
    await first;
    expect(cubit.state, isA<AuthRequestSuccess>());
  });

  test('failure permits a later successful submission', () async {
    await cubit.submit(
      request: () async =>
          throw const AuthException(AuthErrorCode.networkRequestFailed),
    );
    expect(cubit.state, isA<AuthRequestFailure>());
    await cubit.submit(request: () async => const Result.success());
    expect(cubit.state, isA<AuthRequestSuccess>());
  });

  test('success arriving after close emits no state', () async {
    final pending = Completer<Result>();
    final request = cubit.submit(request: () => pending.future);
    await cubit.close();
    pending.complete(const Result.success());
    await request;
    expect(cubit.state, isA<AuthRequestLoading>());
  });

  test('failure arriving after close emits no state', () async {
    final pending = Completer<Result>();
    final request = cubit.submit(request: () => pending.future);
    await cubit.close();
    pending.completeError(
      const AuthException(AuthErrorCode.networkRequestFailed),
    );
    await request;
    expect(cubit.state, isA<AuthRequestLoading>());
  });

  test('closed cubits ignore requests', () async {
    await cubit.close();
    int calls = 0;
    await cubit.submit(
      request: () async {
        calls++;
        return const Result.success();
      },
    );
    expect(calls, 0);
  });
}

final class _RequestCubit extends AuthRequestCubit {
  Future<void> submit({required Future<Result> Function() request}) {
    return executeRequest(request);
  }
}
