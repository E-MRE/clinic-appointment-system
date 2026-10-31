import 'package:clinic_appointment_system/core/enums/time_error_code.dart';
import 'package:clinic_appointment_system/core/errors/time_exception.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimeRange', () {
    test('rejects equal endpoints and an end before the start', () {
      final time = ClockTime(hour: 9, minute: 0);

      expect(
        () => TimeRange(start: time, end: time),
        throwsA(
          isA<TimeException>().having(
            (error) => error.code,
            'code',
            TimeErrorCode.endBeforeStart,
          ),
        ),
      );
      expect(
        () => TimeRange(start: time, end: ClockTime(hour: 8, minute: 59)),
        throwsA(isA<TimeException>()),
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

    test('encloses ranges only when both boundaries fit', () {
      final outer = _range(510, 720);
      expect(outer.encloses(_range(510, 720)), isTrue);
      expect(outer.encloses(_range(540, 720)), isTrue);
      expect(outer.encloses(_range(720, 780)), isFalse);
      expect(outer.encloses(_range(450, 510)), isFalse);
      expect(outer.encloses(_range(509, 720)), isFalse);
      expect(outer.encloses(_range(510, 721)), isFalse);
      expect(outer.encloses(_range(660, 840)), isFalse);
    });

    test('a range spanning a gap is enclosed by neither segment', () {
      final morning = _range(480, 600);
      final afternoon = _range(660, 780);
      final spanning = _range(540, 720);
      expect(morning.encloses(spanning), isFalse);
      expect(afternoon.encloses(spanning), isFalse);
    });

    test('duration is measured in minutes', () {
      expect(_range(510, 720).durationMinutes, 210);
      expect(_range(0, 1).durationMinutes, 1);
    });
  });
}

TimeRange _range(int start, int end) {
  return TimeRange(
    start: ClockTime.fromMinutes(start),
    end: ClockTime.fromMinutes(end),
  );
}
