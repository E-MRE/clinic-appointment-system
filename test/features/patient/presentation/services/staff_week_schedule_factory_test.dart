import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/weekly_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/services/slot_generator.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/patient/presentation/enums/booking_day_status.dart';
import 'package:clinic_appointment_system/features/patient/presentation/enums/day_period.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/clock_time_day_period.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_schedule_day.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_slot.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_week_schedule.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_week_schedule_request.dart';
import 'package:clinic_appointment_system/features/patient/presentation/services/staff_week_schedule_factory.dart';
import 'package:clinic_appointment_system/features/patient/presentation/services/staff_week_schedule_reader.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/patient_fixtures.dart';

void main() {
  const fixtures = PatientFixtures();
  final murat = fixtures.staff[1];
  final service = fixtures.services[1];
  final tuesday = CalendarDate(year: 2026, month: 10, day: 20);
  final wednesday = CalendarDate(year: 2026, month: 10, day: 21);
  final thursday = CalendarDate(year: 2026, month: 10, day: 22);
  const reader = StaffWeekScheduleReader();
  const scheduleFactory = StaffWeekScheduleFactory(SlotGenerator());

  StaffWeekScheduleRequest request({WorkingHours? hours}) {
    return StaffWeekScheduleRequest(
      staff: murat,
      service: service,
      weekStart: fixtures.weekStart,
      branchHours: hours ?? fixtures.branchHours,
    );
  }

  StaffWeekSchedule schedule({
    DateTime? now,
    WorkingHours? hours,
    StaffAvailability? availability,
  }) {
    return scheduleFactory.create(
      request: request(hours: hours),
      availability: availability ?? fixtures.muratAvailability,
      bookedSlots: [
        fixtures.booked('t', tuesday, fixtures.range(9, 20, 20)),
        fixtures.booked('w', wednesday, fixtures.range(9, 0, 40)),
      ],
      now: now ?? fixtures.now,
    );
  }

  StaffScheduleDay? dayOn(StaffWeekSchedule schedule, CalendarDate date) {
    return reader.dayOn(schedule, date);
  }

  List<String> starts(Iterable<StaffSlot> slots) {
    return [for (final slot in slots) '${slot.range.start}'];
  }

  test('lists Monday to Saturday when the branch is closed on Sunday', () {
    final days = schedule().days;
    expect(days, hasLength(6));
    expect(days.first.date, fixtures.weekStart);
    expect(days.last.date, CalendarDate(year: 2026, month: 10, day: 24));
  });

  test('adds Sunday when the branch opens on Sunday', () {
    final hours = WorkingHours({
      for (final day in Weekday.values) day: [fixtures.range(8, 0, 600)],
    });
    final days = schedule(hours: hours).days;
    expect(days, hasLength(7));
    expect(days.last.date, CalendarDate(year: 2026, month: 10, day: 25));
  });

  test('reports closed, full and free days', () {
    final statuses = [for (final day in schedule().days) day.status];
    expect(statuses, [
      BookingDayStatus.closed,
      BookingDayStatus.available,
      BookingDayStatus.full,
      BookingDayStatus.available,
      BookingDayStatus.closed,
      BookingDayStatus.closed,
    ]);
    expect(dayOn(schedule(), tuesday)?.freeCount, 2);
    expect(dayOn(schedule(), thursday)?.freeCount, 12);
    expect(reader.firstAvailableDay(schedule())?.date, tuesday);
  });

  test('marks slots overlapping a booked slot as taken', () {
    final slots = dayOn(schedule(), tuesday)?.slots.toList() ?? [];
    expect(starts(slots), ['09:00', '09:20', '09:40']);
    expect([for (final slot in slots) slot.isTaken], [false, true, false]);
    expect(
      reader.isFree(schedule(), tuesday, fixtures.range(9, 20, 20)),
      isFalse,
    );
    expect(
      reader.isFree(schedule(), tuesday, fixtures.range(9, 40, 20)),
      isTrue,
    );
  });

  test('keeps a slot starting at now and drops earlier ones', () {
    final atStart = schedule(now: DateTime(2026, 10, 20, 9));
    expect(starts(dayOn(atStart, tuesday)?.slots ?? []).first, '09:00');
    final justAfter = schedule(now: DateTime(2026, 10, 20, 9, 0, 1));
    expect(starts(dayOn(justAfter, tuesday)?.slots ?? []), ['09:20', '09:40']);
  });

  test('a day whose slots are all past counts as closed', () {
    final late = schedule(now: DateTime(2026, 10, 20, 9, 41));
    expect(dayOn(late, tuesday)?.status, BookingDayStatus.closed);
    expect(dayOn(late, tuesday)?.groups, isEmpty);
    expect(reader.firstAvailableDay(late)?.date, thursday);
  });

  test('groups slots by availability window with its period', () {
    final groups = dayOn(schedule(), thursday)?.groups ?? [];
    expect(
      [for (final group in groups) group.window],
      [fixtures.range(9, 0, 180), fixtures.range(13, 30, 60)],
    );
    expect(
      [for (final group in groups) group.period],
      [DayPeriod.morning, DayPeriod.afternoon],
    );
    expect(starts(groups.last.slots), ['13:30', '13:50', '14:10']);
  });

  test('windows outside branch hours produce no slots', () {
    final availability = StaffAvailability(
      staffId: 'murat',
      branchId: 'branch',
      weekly: [
        WeeklyWindow(
          weekday: Weekday.thursday,
          range: fixtures.range(17, 30, 60),
        ),
      ],
    );
    final day = dayOn(schedule(availability: availability), thursday);
    expect(day?.status, BookingDayStatus.closed);
  });

  test('periods are half-open at 12:00 and 17:00', () {
    DayPeriod at(int hour, int minute) {
      return ClockTime(hour: hour, minute: minute).dayPeriod;
    }

    expect(at(11, 59), DayPeriod.morning);
    expect(at(12, 0), DayPeriod.afternoon);
    expect(at(16, 59), DayPeriod.afternoon);
    expect(at(17, 0), DayPeriod.evening);
  });
}
