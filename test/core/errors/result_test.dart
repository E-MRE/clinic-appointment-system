import 'package:clinic_appointment_system/core/errors/failure.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('success retains its typed value and maps it', () {
    const Result<int> result = Success(21);
    expect(
      result.fold(onSuccess: (value) => value * 2, onFailure: (_) => -1),
      42,
    );
    expect((result.map((value) => '$value') as Success<String>).value, '21');
  });

  test('failure propagates unchanged without calling success callbacks', () {
    const failure = ConflictFailure();
    const Result<int> result = Failed(failure);
    expect(
      result.fold(
        onSuccess: (_) => fail('Unexpected success'),
        onFailure: (error) => error,
      ),
      same(failure),
    );
    final mapped = result.map<String>((_) => fail('Unexpected mapping'));
    expect((mapped as Failed<String>).failure, same(failure));
  });

  test('nullable success is distinct from failure', () {
    const Result<String?> result = Success(null);
    expect(
      result.fold(onSuccess: (value) => value == null, onFailure: (_) => false),
      isTrue,
    );
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
