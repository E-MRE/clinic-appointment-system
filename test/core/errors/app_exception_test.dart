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
}

final class _BookingException extends AppException {
  const _BookingException({super.message});
}
