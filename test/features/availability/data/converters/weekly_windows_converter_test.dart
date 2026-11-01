import 'package:clinic_appointment_system/features/availability/data/converters/weekly_windows_converter.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> week() => {
  'monday': [
    {'start': '09:00', 'end': '12:00'},
  ],
  'tuesday': <dynamic>[],
  'wednesday': <dynamic>[],
  'thursday': <dynamic>[],
  'friday': <dynamic>[],
  'saturday': <dynamic>[],
  'sunday': <dynamic>[],
};

void main() {
  const converter = WeeklyWindowsConverter();
  test('round trips all weekdays and ranges', () {
    expect(converter.toJson(converter.fromJson(week())), week());
  });
  for (final entry in <String, Map<String, dynamic> Function()>{
    'missing weekday': () => week()..remove('sunday'),
    'extra weekday': () => week()..['holiday'] = <dynamic>[],
    'non-list day': () => week()..['monday'] = 'bad',
    'bad time': () => week()
      ..['monday'] = [
        {'start': '9:00', 'end': '12:00'},
      ],
    'end before start': () => week()
      ..['monday'] = [
        {'start': '12:00', 'end': '09:00'},
      ],
  }.entries) {
    test('rejects ${entry.key}', () {
      expect(() => converter.fromJson(entry.value()), throwsFormatException);
    });
  }
}
