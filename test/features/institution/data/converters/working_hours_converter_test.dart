import 'package:clinic_appointment_system/core/enums/time_error_code.dart';
import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/core/errors/time_exception.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/institution/data/converters/working_hours_converter.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const converter = WorkingHoursConverter();

  test('writes and reads all seven weekdays including a closed day', () {
    final workingHours = WorkingHours({
      Weekday.monday: [
        TimeRange(
          start: ClockTime(hour: 9, minute: 0),
          end: ClockTime(hour: 12, minute: 0),
        ),
      ],
    });

    final json = converter.toJson(workingHours);
    expect(json.keys, {
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    });
    expect(json['monday'], [
      {'start': '09:00', 'end': '12:00'},
    ]);
    expect(json['sunday'], isEmpty);
    expect(converter.fromJson(json), workingHours);
  });

  test('rejects an unknown weekday key', () {
    final json = _closedWeek()..['holiday'] = <Map<String, String>>[];

    expect(() => converter.fromJson(json), throwsFormatException);
  });

  test('rejects overlapping stored ranges', () {
    final json = _closedWeek()
      ..['monday'] = [
        {'start': '09:00', 'end': '12:00'},
        {'start': '11:30', 'end': '14:00'},
      ];

    expect(
      () => converter.fromJson(json),
      throwsA(
        isA<InstitutionException>().having(
          (error) => error.code,
          'code',
          InstitutionErrorCode.overlappingRanges,
        ),
      ),
    );
  });

  test('rejects inverted stored ranges', () {
    final json = _closedWeek()
      ..['monday'] = [
        {'start': '12:00', 'end': '09:00'},
      ];

    expect(
      () => converter.fromJson(json),
      throwsA(
        isA<TimeException>().having(
          (error) => error.code,
          'code',
          TimeErrorCode.endBeforeStart,
        ),
      ),
    );
  });
}

Map<String, dynamic> _closedWeek() {
  return {
    'monday': <Map<String, String>>[],
    'tuesday': <Map<String, String>>[],
    'wednesday': <Map<String, String>>[],
    'thursday': <Map<String, String>>[],
    'friday': <Map<String, String>>[],
    'saturday': <Map<String, String>>[],
    'sunday': <Map<String, String>>[],
  };
}
