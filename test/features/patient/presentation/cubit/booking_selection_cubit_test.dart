import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/booking_selection_cubit.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_week_schedule.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_week_schedule_request.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/time/support/fixed_clock.dart';
import '../doubles/patient_fixtures.dart';

void main() {
  const fixtures = PatientFixtures();
  final internal = fixtures.services[1];
  final cardio = fixtures.services[0];
  final murat = fixtures.staff[1];
  final tuesday = CalendarDate(year: 2026, month: 10, day: 20);
  final thursday = CalendarDate(year: 2026, month: 10, day: 22);
  late BookingSelectionCubit cubit;

  setUp(() => cubit = BookingSelectionCubit(FixedClock(fixtures.now)));
  tearDown(() => cubit.close());

  StaffWeekSchedule schedule({CalendarDate? weekStart, DateTime? now}) {
    return StaffWeekSchedule(
      request: StaffWeekScheduleRequest(
        staff: murat,
        service: internal,
        weekStart: weekStart ?? fixtures.weekStart,
        branchHours: fixtures.branchHours,
      ),
      availability: fixtures.muratAvailability,
      bookedSlots: [fixtures.booked('t', tuesday, fixtures.range(9, 20, 20))],
      now: now ?? fixtures.now,
    );
  }

  void chooseAll() {
    cubit
      ..selectService(internal)
      ..selectStaff(murat)
      ..selectDate(tuesday)
      ..selectSlot(fixtures.range(9, 40, 20));
  }

  test('starts in the clock week with nothing chosen', () {
    expect(cubit.state.weekStart, fixtures.weekStart);
    expect(cubit.state.service, isNull);
    expect(cubit.state.isComplete, isFalse);
    expect(cubit.state.canShowPreviousWeek, isFalse);
  });

  test('a new service clears the staff member, day and slot', () {
    chooseAll();
    expect(cubit.state.isComplete, isTrue);
    cubit.selectService(cardio);
    expect(cubit.state.service, cardio);
    expect(cubit.state.staff, isNull);
    expect(cubit.state.date, isNull);
    expect(cubit.state.slot, isNull);
  });

  test('choosing the current service again keeps the choices', () {
    chooseAll();
    cubit.selectService(internal);
    expect(cubit.state.isComplete, isTrue);
  });

  test('a new staff member or week clears the day and slot', () {
    chooseAll();
    cubit.selectStaff(fixtures.staff[0]);
    expect(cubit.state.date, isNull);
    expect(cubit.state.service, internal);
    chooseAll();
    cubit.showNextWeek();
    expect(cubit.state.weekStart, CalendarDate(year: 2026, month: 10, day: 26));
    expect(cubit.state.staff, murat);
    expect(cubit.state.date, isNull);
    expect(cubit.state.slot, isNull);
  });

  test('a new day clears the slot', () {
    chooseAll();
    cubit.selectDate(thursday);
    expect(cubit.state.date, thursday);
    expect(cubit.state.slot, isNull);
  });

  test('previous week stops at the current week', () {
    cubit.showPreviousWeek();
    expect(cubit.state.weekStart, fixtures.weekStart);
    cubit
      ..showNextWeek()
      ..showPreviousWeek();
    expect(cubit.state.weekStart, fixtures.weekStart);
    expect(cubit.state.canShowPreviousWeek, isFalse);
  });

  test('a schedule picks the first day with a free slot', () {
    cubit
      ..selectService(internal)
      ..selectStaff(murat)
      ..applySchedule(schedule());
    expect(cubit.state.date, tuesday);
    cubit.applySchedule(schedule(now: DateTime(2026, 10, 20, 12)));
    expect(cubit.state.date, tuesday);
  });

  test('a fully booked week chooses no day', () {
    cubit
      ..selectService(internal)
      ..selectStaff(murat)
      ..applySchedule(schedule(now: DateTime(2026, 10, 25)));
    expect(cubit.state.date, isNull);
  });

  test('a schedule of earlier choices is ignored', () {
    cubit
      ..selectService(internal)
      ..selectStaff(murat)
      ..showNextWeek()
      ..applySchedule(schedule());
    expect(cubit.state.date, isNull);
  });

  test('a schedule clears a chosen slot that is no longer free', () {
    cubit
      ..selectService(internal)
      ..selectStaff(murat)
      ..selectDate(tuesday)
      ..selectSlot(fixtures.range(9, 20, 20))
      ..applySchedule(schedule());
    expect(cubit.state.slot, isNull);
    cubit
      ..selectSlot(fixtures.range(9, 40, 20))
      ..applySchedule(schedule());
    expect(cubit.state.slot, fixtures.range(9, 40, 20));
  });

  test('search and department limit filter bookable services', () {
    final catalog = fixtures.catalog;
    List<String> ids() {
      return [
        for (final service in cubit.state.servicesIn(catalog)) service.id,
      ];
    }

    cubit.limitToDepartment('cardio');
    expect(ids(), ['cardio-exam']);
    cubit.removeDepartmentLimit();
    expect(ids(), hasLength(4));
    cubit.search('  LİPİD ');
    expect(ids(), ['lipid']);
    cubit.search('DAHILIYE');
    expect(ids(), isEmpty);
    cubit.search('dahiliye');
    expect(ids(), ['internal-exam']);
  });
}
