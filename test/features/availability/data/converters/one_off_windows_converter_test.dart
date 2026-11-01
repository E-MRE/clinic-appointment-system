import 'package:clinic_appointment_system/features/availability/data/converters/one_off_windows_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const converter = OneOffWindowsConverter();
  final valid = [
    {'date': '2026-11-02', 'start': '16:30', 'end': '17:30'},
  ];
  test('round trips dated windows', () {
    expect(converter.toJson(converter.fromJson(valid)), valid);
  });
  for (final entry in <String, List<dynamic>>{
    'bad date': [
      {'date': '2026-02-30', 'start': '09:00', 'end': '12:00'},
    ],
    'extra key': [
      {'date': '2026-11-02', 'start': '09:00', 'end': '12:00', 'extra': true},
    ],
    'bad time': [
      {'date': '2026-11-02', 'start': 'bad', 'end': '12:00'},
    ],
    'end before start': [
      {'date': '2026-11-02', 'start': '12:00', 'end': '09:00'},
    ],
  }.entries) {
    test('rejects ${entry.key}', () {
      expect(() => converter.fromJson(entry.value), throwsFormatException);
    });
  }
}
