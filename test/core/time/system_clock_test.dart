import 'package:clinic_appointment_system/core/time/system_clock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SystemClock reads the current system instant', () {
    final before = DateTime.now();
    final instant = const SystemClock().now();
    final after = DateTime.now();
    expect(instant.isBefore(before), isFalse);
    expect(instant.isAfter(after), isFalse);
  });
}
