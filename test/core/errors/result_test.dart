import 'package:clinic_appointment_system/core/errors/failure.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('success exposes its typed value through pattern matching', () {
    const Result<int> result = Success(21);
    final value = switch (result) {
      Success<int>(:final value) => value,
      Failed<int>() => fail('Unexpected failure'),
    };
    expect(value, 21);
  });

  test('failed result retains the original failure', () {
    const failure = ConflictFailure();
    const Result<int> result = Failed(failure);
    final error = switch (result) {
      Success<int>() => fail('Unexpected success'),
      Failed<int>(:final failure) => failure,
    };
    expect(error, same(failure));
  });

  test('nullable success is distinct from failure', () {
    const Result<String?> result = Success(null);
    final isNullSuccess = switch (result) {
      Success<String?>(:final value) => value == null,
      Failed<String?>() => false,
    };
    expect(isNullSuccess, isTrue);
  });

  test(
    'failures can be handled exhaustively without framework dependencies',
    () {
      String category(Failure failure) => switch (failure) {
        ValidationFailure(:final field) => 'validation:$field',
        UnauthorizedFailure() => 'unauthorized',
        NotFoundFailure() => 'notFound',
        ConflictFailure() => 'conflict',
        UnexpectedFailure() => 'unexpected',
      };
      expect(
        category(const ValidationFailure(field: 'email')),
        'validation:email',
      );
      expect(category(const UnauthorizedFailure()), 'unauthorized');
      expect(category(const NotFoundFailure()), 'notFound');
      expect(category(const ConflictFailure()), 'conflict');
      expect(category(const UnexpectedFailure()), 'unexpected');
    },
  );
}
