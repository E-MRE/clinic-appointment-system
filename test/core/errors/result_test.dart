import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'success and error expose their status with an empty default message',
    () {
      const success = Result.success();
      const error = Result.error();
      expect(success.isSuccess, isTrue);
      expect(success.message, isEmpty);
      expect(error.isSuccess, isFalse);
      expect(error.message, isEmpty);
    },
  );

  test('success and error preserve supplied messages', () {
    const success = Result.success(message: 'Saved');
    const error = Result.error(message: 'Could not save');
    expect(success.message, 'Saved');
    expect(error.message, 'Could not save');
  });
}
