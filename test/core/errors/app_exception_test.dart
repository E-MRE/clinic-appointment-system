import 'package:clinic_appointment_system/core/errors/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('custom exceptions can be caught through the shared base type', () {
    expect(
      () => throw const _BookingException(message: 'Slot is occupied'),
      throwsA(
        isA<AppException>()
            .having((error) => error.message, 'message', 'Slot is occupied')
            .having(
              (error) => error.toString(),
              'description',
              '_BookingException: Slot is occupied',
            ),
      ),
    );
  });

  test(
    'base exception implements Exception and defaults to an empty message',
    () {
      const error = AppException();
      expect(error, isA<Exception>());
      expect(error.message, isEmpty);
    },
  );
  test('validation exception preserves the invalid field and message', () {
    const error = ValidationException(field: 'email', message: 'Invalid email');
    expect(error.field, 'email');
    expect(error.message, 'Invalid email');
    expect(error, isA<AppException>());
    expect(error, isA<Exception>());
  });

  test('specific exception types support separate catch handlers', () {
    String handle(AppException error) {
      try {
        throw error;
      } on ValidationException {
        return 'validation';
      } on UnauthorizedException {
        return 'unauthorized';
      } on NotFoundException {
        return 'notFound';
      } on ConflictException {
        return 'conflict';
      } on UnexpectedException {
        return 'unexpected';
      }
    }

    expect(handle(const ValidationException(field: 'email')), 'validation');
    expect(handle(const UnauthorizedException()), 'unauthorized');
    expect(handle(const NotFoundException()), 'notFound');
    expect(handle(const ConflictException()), 'conflict');
    expect(handle(const UnexpectedException()), 'unexpected');
  });

  test('specific exceptions retain messages and identify their type', () {
    final errors = <AppException>[
      const UnauthorizedException(message: 'Sign in required'),
      const NotFoundException(message: 'Appointment missing'),
      const ConflictException(message: 'Slot occupied'),
      const UnexpectedException(message: 'Operation failed'),
    ];
    for (final error in errors) {
      expect(error, isA<Exception>());
      expect(error.message, isNotEmpty);
      expect(error.toString(), '${error.runtimeType}: ${error.message}');
    }
  });
}

final class _BookingException extends AppException {
  const _BookingException({super.message});
}
