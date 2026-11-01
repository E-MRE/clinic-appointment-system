import 'package:clinic_appointment_system/core/constants/working_hours_constants.dart';
import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/working_hours_editor_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('working hours editor', () {
    test(
      'new branches start Monday through Friday from 09:00 to 18:00',
      () async {
        final cubit = WorkingHoursEditorCubit();

        for (final day in Weekday.values.take(5)) {
          expect(cubit.state.day(day).isOpen, isTrue);
          expect(cubit.state.day(day).ranges, hasLength(1));
          expect(
            cubit.state.day(day).ranges.single.start,
            _time(WorkingHoursConstants.openingHour),
          );
          expect(
            cubit.state.day(day).ranges.single.end,
            _time(WorkingHoursConstants.closingHour),
          );
        }
        expect(cubit.state.day(Weekday.saturday).isOpen, isFalse);
        expect(cubit.state.day(Weekday.sunday).isOpen, isFalse);
        expect(cubit.build(), isNotNull);
        await cubit.close();
      },
    );

    test('an existing schedule initializes the editor in edit mode', () async {
      final existing = WorkingHours({
        Weekday.monday: [TimeRange(start: _time(8), end: _time(12))],
        Weekday.sunday: [TimeRange(start: _time(10), end: _time(14))],
      });
      final cubit = WorkingHoursEditorCubit();
      cubit.initialize(existing);

      expect(cubit.build(), existing);
      expect(cubit.state.day(Weekday.tuesday).isOpen, isFalse);
      expect(cubit.state.day(Weekday.sunday).ranges.single.start, _time(10));
      await cubit.close();
    });

    test(
      'toggle closes a day and reopening restores or defaults its range',
      () async {
        final cubit = WorkingHoursEditorCubit();

        cubit.toggleDay(Weekday.monday);
        expect(cubit.state.day(Weekday.monday).isOpen, isFalse);
        expect(cubit.build()?.isClosedOn(Weekday.monday), isTrue);
        cubit.toggleDay(Weekday.saturday);
        expect(cubit.state.day(Weekday.saturday).isOpen, isTrue);
        expect(
          cubit.state.day(Weekday.saturday).ranges.single.start,
          _time(WorkingHoursConstants.openingHour),
        );
        await cubit.close();
      },
    );

    test('ranges can be added, updated and removed', () async {
      final cubit = WorkingHoursEditorCubit();
      cubit.addRange(
        Weekday.monday,
        _time(WorkingHoursConstants.closingHour),
        _time(20),
      );
      expect(cubit.state.day(Weekday.monday).ranges, hasLength(2));

      cubit.updateRange(
        Weekday.monday,
        1,
        _time(WorkingHoursConstants.closingHour),
        _time(20),
      );
      expect(
        cubit.state.day(Weekday.monday).ranges[1].start,
        _time(WorkingHoursConstants.closingHour),
      );
      expect(cubit.state.day(Weekday.monday).error, isNull);

      cubit.removeRange(Weekday.monday, 1);
      expect(cubit.state.day(Weekday.monday).ranges, hasLength(1));
      expect(
        cubit.build(),
        WorkingHours({
          for (final day in Weekday.values)
            day: day.index < 5
                ? [
                    TimeRange(
                      start: _time(WorkingHoursConstants.openingHour),
                      end: _time(WorkingHoursConstants.closingHour),
                    ),
                  ]
                : const <TimeRange>[],
        }),
      );
      await cubit.close();
    });

    test(
      'adding a range without values chooses the next available hour',
      () async {
        final cubit = WorkingHoursEditorCubit();

        cubit.addRange(Weekday.monday);

        expect(cubit.state.day(Weekday.monday).ranges, hasLength(2));
        expect(
          cubit.state.day(Weekday.monday).ranges[1].start,
          _time(WorkingHoursConstants.closingHour),
        );
        expect(cubit.state.day(Weekday.monday).ranges[1].end, _time(19));
        expect(cubit.state.day(Weekday.monday).error, isNull);
        await cubit.close();
      },
    );

    test(
      'copying a day applies its ranges to Monday through Friday only',
      () async {
        final cubit = WorkingHoursEditorCubit();
        cubit.toggleDay(Weekday.saturday);
        cubit.updateRange(Weekday.saturday, 0, _time(11), _time(15));

        cubit.copyToWeekdays(Weekday.saturday);

        for (final day in Weekday.values.take(5)) {
          expect(cubit.state.day(day).ranges.single.start, _time(11));
          expect(cubit.state.day(day).ranges.single.end, _time(15));
        }
        expect(
          cubit.state.day(Weekday.saturday).ranges.single.start,
          _time(11),
        );
        expect(cubit.build()?.rangesOn(Weekday.sunday), isEmpty);
        await cubit.close();
      },
    );

    test(
      'inverted and empty ranges report closeBeforeOpen for that day',
      () async {
        final cubit = WorkingHoursEditorCubit();
        cubit.updateRange(
          Weekday.monday,
          0,
          _time(WorkingHoursConstants.closingHour),
          _time(WorkingHoursConstants.openingHour),
        );
        expect(
          cubit.state.day(Weekday.monday).error,
          InstitutionErrorCode.closeBeforeOpen,
        );
        expect(cubit.build(), isNull);

        cubit.updateRange(
          Weekday.monday,
          0,
          _time(WorkingHoursConstants.openingHour),
          _time(WorkingHoursConstants.openingHour),
        );
        expect(
          cubit.state.day(Weekday.monday).error,
          InstitutionErrorCode.closeBeforeOpen,
        );
        await cubit.close();
      },
    );

    test(
      'overlapping ranges identify the affected day and block build',
      () async {
        final cubit = WorkingHoursEditorCubit();
        cubit.addRange(
          Weekday.wednesday,
          _time(WorkingHoursConstants.closingHour),
          _time(20),
        );
        cubit.updateRange(Weekday.wednesday, 1, _time(17), _time(19));

        expect(
          cubit.state.day(Weekday.wednesday).error,
          InstitutionErrorCode.overlappingRanges,
        );
        expect(cubit.state.day(Weekday.tuesday).error, isNull);
        expect(cubit.build(), isNull);
        await cubit.close();
      },
    );

    test('build returns equal WorkingHours when the draft is valid', () async {
      final expected = WorkingHours({
        Weekday.monday: [
          TimeRange(
            start: _time(WorkingHoursConstants.openingHour),
            end: _time(WorkingHoursConstants.closingHour),
          ),
        ],
        Weekday.tuesday: [
          TimeRange(
            start: _time(WorkingHoursConstants.openingHour),
            end: _time(WorkingHoursConstants.closingHour),
          ),
        ],
        Weekday.wednesday: [
          TimeRange(
            start: _time(WorkingHoursConstants.openingHour),
            end: _time(WorkingHoursConstants.closingHour),
          ),
        ],
        Weekday.thursday: [
          TimeRange(
            start: _time(WorkingHoursConstants.openingHour),
            end: _time(WorkingHoursConstants.closingHour),
          ),
        ],
        Weekday.friday: [
          TimeRange(
            start: _time(WorkingHoursConstants.openingHour),
            end: _time(WorkingHoursConstants.closingHour),
          ),
        ],
      });
      final cubit = WorkingHoursEditorCubit();

      expect(cubit.build(), expected);
      await cubit.close();
    });
  });
}

ClockTime _time(int hour) => ClockTime(hour: hour, minute: 0);
