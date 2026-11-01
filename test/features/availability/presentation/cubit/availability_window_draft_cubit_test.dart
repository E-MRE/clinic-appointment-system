import 'package:clinic_appointment_system/core/enums/time_error_code.dart';
import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/availability_window_draft_cubit.dart';
import 'package:clinic_appointment_system/features/availability/presentation/enums/availability_repeat.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/time/support/fixed_clock.dart';
import '../../domain/support/availability_fixture.dart';

void main() {
  const fixture = AvailabilityFixture();
  late AvailabilityWindowDraftCubit cubit;
  final start = ClockTime.fromMinutes(540);
  final end = ClockTime.fromMinutes(600);

  setUp(() {
    cubit = AvailabilityWindowDraftCubit(FixedClock(DateTime(2026, 11, 2)));
    addTearDown(cubit.close);
  });

  test('initial draft is weekly Monday with today and no times', () {
    expect(cubit.state.repeat, AvailabilityRepeat.weekly);
    expect(cubit.state.weekday, Weekday.monday);
    expect(cubit.state.date, fixture.monday);
    expect(cubit.state.start, isNull);
    expect(cubit.state.end, isNull);
    expect(cubit.state.window, isNull);
    expect(cubit.state.timeError, isNull);
  });

  test('startWeekly selects a day and resets both times', () {
    cubit.changeStart(start);
    cubit.changeEnd(end);
    cubit.selectRepeat(AvailabilityRepeat.oneOff);
    cubit.startWeekly(Weekday.friday);
    expect(cubit.state.repeat, AvailabilityRepeat.weekly);
    expect(cubit.state.weekday, Weekday.friday);
    expect(cubit.state.start, isNull);
    expect(cubit.state.end, isNull);
  });

  test('startOneOff restores today and resets both times', () {
    cubit.selectDate(fixture.tuesday);
    cubit.changeStart(start);
    cubit.changeEnd(end);
    cubit.startOneOff();
    expect(cubit.state.repeat, AvailabilityRepeat.oneOff);
    expect(cubit.state.date, fixture.monday);
    expect(cubit.state.start, isNull);
    expect(cubit.state.end, isNull);
  });

  test('reset restores the initial draft', () {
    final initial = cubit.state;
    cubit.selectRepeat(AvailabilityRepeat.oneOff);
    cubit.selectWeekday(Weekday.friday);
    cubit.selectDate(fixture.tuesday);
    cubit.changeStart(start);
    cubit.changeEnd(end);
    cubit.reset();
    expect(cubit.state, initial);
  });

  test('window remains null until both endpoints are set in either order', () {
    cubit.changeStart(start);
    expect(cubit.state.window, isNull);
    cubit.changeEnd(end);
    expect(cubit.state.window, fixture.weekly(540, 600));
    cubit.reset();
    cubit.changeEnd(end);
    expect(cubit.state.window, isNull);
    cubit.changeStart(start);
    expect(cubit.state.window, fixture.weekly(540, 600));
    expect(cubit.state.timeError, isNull);
  });

  test('equal and reversed times report the TimeRange domain error', () {
    cubit.changeStart(end);
    cubit.changeEnd(end);
    expect(cubit.state.timeError, TimeErrorCode.endBeforeStart);
    cubit.changeEnd(start);
    expect(cubit.state.timeError, TimeErrorCode.endBeforeStart);
  });

  test(
    'repeat strategies build the selected weekly or dated window by value',
    () {
      cubit.selectWeekday(Weekday.tuesday);
      cubit.selectDate(fixture.tuesday);
      cubit.changeStart(start);
      cubit.changeEnd(end);
      expect(
        cubit.state.window,
        fixture.weekly(540, 600, day: Weekday.tuesday),
      );
      cubit.selectRepeat(AvailabilityRepeat.oneOff);
      expect(
        cubit.state.window,
        fixture.oneOff(540, 600, date: fixture.tuesday),
      );
    },
  );

  test(
    'draft copies preserve fields and can explicitly clear either endpoint',
    () {
      cubit.selectDate(CalendarDate(year: 2026, month: 11, day: 4));
      cubit.changeStart(start);
      cubit.changeEnd(end);
      final draft = cubit.state;
      expect(draft.copyWith(), draft);
      final withoutStart = draft.withoutStart();
      expect(withoutStart.start, isNull);
      expect(withoutStart.end, end);
      expect(withoutStart.date, draft.date);
      expect(withoutStart.window, isNull);
      final withoutEnd = draft.withoutEnd();
      expect(withoutEnd.start, start);
      expect(withoutEnd.end, isNull);
      expect(withoutEnd.window, isNull);
    },
  );
}
