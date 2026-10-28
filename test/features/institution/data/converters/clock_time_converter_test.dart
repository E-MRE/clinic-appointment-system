import 'package:clinic_appointment_system/features/institution/data/converters/clock_time_converter.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/clock_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const converter = ClockTimeConverter();

  test('parses and writes zero-padded HH:mm values', () {
    expect(converter.fromJson('09:05'), ClockTime(hour: 9, minute: 5));
    expect(converter.toJson(ClockTime(hour: 9, minute: 5)), '09:05');
  });

  test('rejects malformed and out-of-range clock times', () {
    for (final value in ['9:05', '09:5', '24:00', '12:60', 'aa:bb']) {
      expect(() => converter.fromJson(value), throwsFormatException);
    }
  });
}
