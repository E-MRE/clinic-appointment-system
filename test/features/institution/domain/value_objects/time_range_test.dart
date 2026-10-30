import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/clock_time.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/time_range.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimeRange', () {
    test('rejects equal endpoints and an end before the start', () {
      final time = ClockTime(hour: 9, minute: 0);

      expect(
        () => TimeRange(start: time, end: time),
        throwsA(
          isA<InstitutionException>().having(
            (error) => error.code,
            'code',
            InstitutionErrorCode.closeBeforeOpen,
          ),
        ),
      );
      expect(
        () => TimeRange(start: time, end: ClockTime(hour: 8, minute: 59)),
        throwsA(isA<InstitutionException>()),
      );
    });

    test('allows adjacent ranges without overlap', () {
      final morning = TimeRange(
        start: ClockTime(hour: 9, minute: 0),
        end: ClockTime(hour: 12, minute: 0),
      );
      final afternoon = TimeRange(
        start: ClockTime(hour: 12, minute: 0),
        end: ClockTime(hour: 13, minute: 0),
      );

      expect(morning.overlaps(afternoon), isFalse);
      expect(afternoon.overlaps(morning), isFalse);
    });

    test('detects contained and partial overlaps', () {
      final outer = TimeRange(
        start: ClockTime(hour: 9, minute: 0),
        end: ClockTime(hour: 13, minute: 0),
      );
      final contained = TimeRange(
        start: ClockTime(hour: 10, minute: 0),
        end: ClockTime(hour: 11, minute: 0),
      );
      final partial = TimeRange(
        start: ClockTime(hour: 12, minute: 0),
        end: ClockTime(hour: 14, minute: 0),
      );

      expect(outer.overlaps(contained), isTrue);
      expect(contained.overlaps(outer), isTrue);
      expect(outer.overlaps(partial), isTrue);
    });

    test('contains the start but excludes the end and compares by value', () {
      final range = TimeRange(
        start: ClockTime(hour: 9, minute: 0),
        end: ClockTime(hour: 12, minute: 0),
      );
      final equalRange = TimeRange(
        start: ClockTime(hour: 9, minute: 0),
        end: ClockTime(hour: 12, minute: 0),
      );

      expect(range.contains(ClockTime(hour: 9, minute: 0)), isTrue);
      expect(range.contains(ClockTime(hour: 12, minute: 0)), isFalse);
      expect(range, equalRange);
      expect(range.hashCode, equalRange.hashCode);
    });
  });
}
