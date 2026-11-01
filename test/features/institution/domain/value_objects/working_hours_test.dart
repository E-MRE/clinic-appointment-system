import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WorkingHours', () {
    test(
      'rejects overlaps on one day but allows the same range on other days',
      () {
        final first = TimeRange(
          start: ClockTime(hour: 9, minute: 0),
          end: ClockTime(hour: 12, minute: 0),
        );
        final overlap = TimeRange(
          start: ClockTime(hour: 11, minute: 0),
          end: ClockTime(hour: 13, minute: 0),
        );

        expect(
          () => WorkingHours({
            Weekday.monday: [first, overlap],
          }),
          throwsA(
            isA<InstitutionException>().having(
              (error) => error.code,
              'code',
              InstitutionErrorCode.overlappingRanges,
            ),
          ),
        );
        expect(
          WorkingHours({
            Weekday.monday: [first],
            Weekday.tuesday: [first],
          }).openDays,
          [Weekday.monday, Weekday.tuesday],
        );
      },
    );

    test('rejects when only the second and third of three ranges overlap', () {
      final first = TimeRange(
        start: ClockTime(hour: 9, minute: 0),
        end: ClockTime(hour: 10, minute: 0),
      );
      final second = TimeRange(
        start: ClockTime(hour: 10, minute: 0),
        end: ClockTime(hour: 11, minute: 0),
      );
      final third = TimeRange(
        start: ClockTime(hour: 10, minute: 30),
        end: ClockTime(hour: 12, minute: 0),
      );

      expect(
        () => WorkingHours({
          Weekday.monday: [first, second, third],
        }),
        throwsA(
          isA<InstitutionException>().having(
            (error) => error.code,
            'code',
            InstitutionErrorCode.overlappingRanges,
          ),
        ),
      );
    });

    test('allows back-to-back ranges and sorts by start', () {
      final afternoon = TimeRange(
        start: ClockTime(hour: 13, minute: 0),
        end: ClockTime(hour: 17, minute: 0),
      );
      final morning = TimeRange(
        start: ClockTime(hour: 9, minute: 0),
        end: ClockTime(hour: 12, minute: 0),
      );
      final noon = TimeRange(
        start: ClockTime(hour: 12, minute: 0),
        end: ClockTime(hour: 13, minute: 0),
      );
      final hours = WorkingHours({
        Weekday.monday: [afternoon, morning, noon],
      });

      expect(hours.rangesOn(Weekday.monday), [morning, noon, afternoon]);
    });

    test('treats missing and empty weekdays as closed', () {
      final hours = WorkingHours({Weekday.tuesday: []});

      expect(hours.isClosedOn(Weekday.monday), isTrue);
      expect(hours.rangesOn(Weekday.monday), isEmpty);
      expect(hours.isClosedOn(Weekday.tuesday), isTrue);
      expect(WorkingHours.closed().openDays, isEmpty);
    });

    test('copies input maps and lists defensively', () {
      final morning = TimeRange(
        start: ClockTime(hour: 9, minute: 0),
        end: ClockTime(hour: 12, minute: 0),
      );
      final afternoon = TimeRange(
        start: ClockTime(hour: 13, minute: 0),
        end: ClockTime(hour: 17, minute: 0),
      );
      final mondayRanges = [morning];
      final input = <Weekday, List<TimeRange>>{Weekday.monday: mondayRanges};
      final hours = WorkingHours(input);

      mondayRanges.add(afternoon);
      input[Weekday.tuesday] = [morning];

      expect(hours.rangesOn(Weekday.monday), [morning]);
      expect(hours.isClosedOn(Weekday.tuesday), isTrue);
      expect(
        () => hours.rangesOn(Weekday.monday).add(afternoon),
        throwsUnsupportedError,
      );
    });

    test('checks open time with inclusive start and exclusive end', () {
      final hours = WorkingHours({
        Weekday.monday: [
          TimeRange(
            start: ClockTime(hour: 9, minute: 0),
            end: ClockTime(hour: 12, minute: 0),
          ),
        ],
      });

      expect(
        hours.isOpenAt(Weekday.monday, ClockTime(hour: 9, minute: 0)),
        isTrue,
      );
      expect(
        hours.isOpenAt(Weekday.monday, ClockTime(hour: 12, minute: 0)),
        isFalse,
      );
      expect(
        hours.isOpenAt(Weekday.monday, ClockTime(hour: 8, minute: 59)),
        isFalse,
      );
    });

    test('lists open days in weekday order and compares by value', () {
      final range = TimeRange(
        start: ClockTime(hour: 9, minute: 0),
        end: ClockTime(hour: 17, minute: 0),
      );
      final first = WorkingHours({
        Weekday.friday: [range],
        Weekday.monday: [range],
        Weekday.wednesday: [range],
      });
      final second = WorkingHours({
        Weekday.monday: [
          TimeRange(
            start: ClockTime(hour: 9, minute: 0),
            end: ClockTime(hour: 17, minute: 0),
          ),
        ],
        Weekday.wednesday: [
          TimeRange(
            start: ClockTime(hour: 9, minute: 0),
            end: ClockTime(hour: 17, minute: 0),
          ),
        ],
        Weekday.friday: [
          TimeRange(
            start: ClockTime(hour: 9, minute: 0),
            end: ClockTime(hour: 17, minute: 0),
          ),
        ],
      });

      expect(first.openDays, [
        Weekday.monday,
        Weekday.wednesday,
        Weekday.friday,
      ]);
      expect(first, second);
      expect(first.hashCode, second.hashCode);
      expect(WorkingHours.closed(), WorkingHours({}));
    });
  });
}
