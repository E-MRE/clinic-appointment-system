import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/clock_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClockTime', () {
    test('accepts both valid day boundaries', () {
      expect(ClockTime(hour: 0, minute: 0).minutesSinceMidnight, 0);
      expect(ClockTime(hour: 23, minute: 59).minutesSinceMidnight, 1439);
    });

    test('rejects hour 24 and negative hour', () {
      expect(
        () => ClockTime(hour: 24, minute: 0),
        throwsA(
          isA<InstitutionException>().having(
            (error) => error.code,
            'code',
            InstitutionErrorCode.invalidTime,
          ),
        ),
      );
      expect(
        () => ClockTime(hour: -1, minute: 0),
        throwsA(isA<InstitutionException>()),
      );
    });

    test('rejects minute 60', () {
      expect(
        () => ClockTime(hour: 12, minute: 60),
        throwsA(isA<InstitutionException>()),
      );
    });

    test('fromMinutes accepts bounds and rejects values outside them', () {
      expect(ClockTime.fromMinutes(0).toString(), '00:00');
      expect(ClockTime.fromMinutes(1439).toString(), '23:59');
      expect(
        () => ClockTime.fromMinutes(-1),
        throwsA(isA<InstitutionException>()),
      );
      expect(
        () => ClockTime.fromMinutes(1440),
        throwsA(isA<InstitutionException>()),
      );
    });

    test('formats with zero padding and compares by value', () {
      final early = ClockTime(hour: 8, minute: 5);
      final sameTime = ClockTime(hour: 8, minute: 5);
      final late = ClockTime(hour: 8, minute: 6);

      expect(early.toString(), '08:05');
      expect(early, sameTime);
      expect(early.hashCode, sameTime.hashCode);
      expect(early.isBefore(late), isTrue);
      expect(late.isAfter(early), isTrue);
      expect(early.compareTo(late), lessThan(0));
    });
  });
}
