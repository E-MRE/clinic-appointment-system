import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_calendar_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_calendar_view.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/time/support/fixed_clock.dart';

void main() {
  group('StaffCalendarCubit', () {
    // 2026-10-28 is a Wednesday
    final todayInstant = DateTime.utc(2026, 10, 28, 10, 30);
    late FixedClock clock;
    late StaffCalendarCubit cubit;

    setUp(() {
      clock = FixedClock(todayInstant);
      cubit = StaffCalendarCubit(clock: clock);
    });

    tearDown(() {
      cubit.close();
    });

    test('initializes with default week view and today anchor', () {
      expect(cubit.state.view, StaffCalendarView.week);
      expect(cubit.state.anchor, CalendarDate(year: 2026, month: 10, day: 28));

      // Mon 2026-10-26 through Sun 2026-11-01 across month boundary
      final visible = cubit.state.visibleDates;
      expect(visible.length, 7);
      expect(visible.first, CalendarDate(year: 2026, month: 10, day: 26));
      expect(visible[1], CalendarDate(year: 2026, month: 10, day: 27));
      expect(visible[2], CalendarDate(year: 2026, month: 10, day: 28));
      expect(visible[3], CalendarDate(year: 2026, month: 10, day: 29));
      expect(visible[4], CalendarDate(year: 2026, month: 10, day: 30));
      expect(visible[5], CalendarDate(year: 2026, month: 10, day: 31));
      expect(visible.last, CalendarDate(year: 2026, month: 11, day: 1));
    });

    test('switches view mode between day and week', () {
      cubit.showDay();
      expect(cubit.state.view, StaffCalendarView.day);
      expect(cubit.state.visibleDates, [
        CalendarDate(year: 2026, month: 10, day: 28),
      ]);

      cubit.showWeek();
      expect(cubit.state.view, StaffCalendarView.week);
      expect(cubit.state.visibleDates.length, 7);
      expect(
        cubit.state.visibleDates.first,
        CalendarDate(year: 2026, month: 10, day: 26),
      );
    });

    test('advances and rewinds by 7 days in week mode', () {
      cubit.next();
      expect(cubit.state.anchor, CalendarDate(year: 2026, month: 11, day: 4));

      cubit.previous();
      expect(cubit.state.anchor, CalendarDate(year: 2026, month: 10, day: 28));
    });

    test('advances and rewinds by 1 day in day mode', () {
      cubit.showDay();

      cubit.next();
      expect(cubit.state.anchor, CalendarDate(year: 2026, month: 10, day: 29));
      expect(cubit.state.visibleDates, [
        CalendarDate(year: 2026, month: 10, day: 29),
      ]);

      cubit.previous();
      expect(cubit.state.anchor, CalendarDate(year: 2026, month: 10, day: 28));
      expect(cubit.state.visibleDates, [
        CalendarDate(year: 2026, month: 10, day: 28),
      ]);
    });

    test('resets anchor to today without changing view mode', () {
      cubit.showDay();
      cubit.selectDate(CalendarDate(year: 2026, month: 12, day: 15));
      expect(cubit.state.anchor, CalendarDate(year: 2026, month: 12, day: 15));

      cubit.today();
      expect(cubit.state.anchor, CalendarDate(year: 2026, month: 10, day: 28));
      expect(cubit.state.view, StaffCalendarView.day);
    });

    test('selectDate sets anchor directly', () {
      final chosen = CalendarDate(year: 2026, month: 11, day: 12);
      cubit.selectDate(chosen);
      expect(cubit.state.anchor, chosen);
    });

    test('visible dates of a week start on Monday across a month boundary', () {
      // 2026-11-01 is a Sunday
      cubit.selectDate(CalendarDate(year: 2026, month: 11, day: 1));
      final visible = cubit.state.visibleDates;
      expect(visible.first, CalendarDate(year: 2026, month: 10, day: 26));
      expect(visible.last, CalendarDate(year: 2026, month: 11, day: 1));
    });
  });
}
