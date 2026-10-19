import 'package:clinic_appointment_system/core/errors/failure.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Result.success represents an operation without data', () {
    const result = Result.success();
    expect(result.isSuccess, isTrue);
    expect(result.failure, isNull);
  });

  test('Result.error retains the original failure', () {
    const failure = ConflictFailure();
    const result = Result.error(failure: failure);
    expect(result.isSuccess, isFalse);
    expect(result.failure, same(failure));
  });

  test('DataResult.success retains typed data', () {
    const result = DataResult<int>.success(data: 21);
    expect(result.isSuccess, isTrue);
    expect(result.data, 21);
    expect(result.failure, isNull);
  });

  test('DataResult.error retains failure without data', () {
    const failure = ConflictFailure();
    const result = DataResult<int>.error(failure: failure);
    expect(result.isSuccess, isFalse);
    expect(result.failure, same(failure));
    expect(result.data, isNull);
  });

  test('nullable successful data is distinct from an error', () {
    const result = DataResult<String?>.success(data: null);
    expect(result.isSuccess, isTrue);
    expect(result.data, isNull);
    expect(result.failure, isNull);
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
