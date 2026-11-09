import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_staff_booked_slots_use_case.dart';
import 'package:clinic_appointment_system/features/availability/domain/services/slot_generator.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/watch_staff_availability_use_case.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/staff_week_schedule_cubit.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/staff_week_schedule_state.dart';
import 'package:clinic_appointment_system/features/patient/presentation/enums/booking_day_status.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/calendar_date_week.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_week_schedule_request.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/time/support/fixed_clock.dart';
import '../doubles/patient_appointment_repository.dart';
import '../doubles/patient_availability_repository.dart';
import '../doubles/patient_fixtures.dart';

void main() {
  const fixtures = PatientFixtures();
  final murat = fixtures.staff[1];
  final ayse = fixtures.staff[0];
  final nextWeek = fixtures.weekStart.addDays(7);
  late PatientAppointmentRepository appointments;
  late PatientAvailabilityRepository availability;
  late StaffWeekScheduleCubit cubit;

  setUp(() {
    appointments = PatientAppointmentRepository();
    availability = PatientAvailabilityRepository();
    cubit = StaffWeekScheduleCubit(
      WatchStaffAvailabilityUseCase(availability),
      WatchStaffBookedSlotsUseCase(appointments),
      FixedClock(fixtures.now),
      const SlotGenerator(),
    );
  });

  tearDown(() async {
    await cubit.close();
    await appointments.bookedSlots.close();
    await appointments.events.close();
    await availability.close();
  });

  StaffWeekScheduleRequest request(Staff staff, CalendarDate weekStart) {
    return StaffWeekScheduleRequest(
      staff: staff,
      service: fixtures.services[1],
      weekStart: weekStart,
      branchHours: fixtures.branchHours,
    );
  }

  String key(Staff staff, CalendarDate date) {
    return PatientAppointmentRepository.bookedSlotsKey(staff.id, date);
  }

  Future<void> emitWeek(StaffWeekScheduleRequest request) async {
    for (final date in request.dates) {
      appointments.bookedSlots.emit(key(request.staff, date), const []);
    }
    await Future<void>.delayed(Duration.zero);
  }

  test('starts idle and subscribes once per listed day', () {
    expect(cubit.state, isA<StaffWeekScheduleIdle>());
    final week = request(murat, fixtures.weekStart);
    cubit.watch(week);
    expect(cubit.state, isA<StaffWeekScheduleLoading>());
    expect(availability.watched.single.staffId, 'murat');
    expect(appointments.bookedSlots.requested, [
      for (final date in week.dates) key(murat, date),
    ]);
  });

  test('emits the schedule once availability and every day arrive', () async {
    final week = request(murat, fixtures.weekStart);
    cubit.watch(week);
    availability.emit(fixtures.muratAvailability);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state, isA<StaffWeekScheduleLoading>());
    await emitWeek(week);
    final state = cubit.state;
    expect(state, isA<StaffWeekScheduleLoaded>());
    final schedule = (state as StaffWeekScheduleLoaded).schedule;
    expect(schedule.request, same(week));
    expect(schedule.firstAvailableDay?.freeCount, 3);
  });

  test('a booked slot update marks the slot taken', () async {
    final week = request(murat, fixtures.weekStart);
    cubit.watch(week);
    availability.emit(fixtures.muratAvailability);
    await emitWeek(week);
    final tuesday = fixtures.weekStart.addDays(1);
    appointments.bookedSlots.emit(key(murat, tuesday), [
      fixtures.booked('x', tuesday, fixtures.range(9, 0, 60)),
    ]);
    await Future<void>.delayed(Duration.zero);
    final schedule = (cubit.state as StaffWeekScheduleLoaded).schedule;
    expect(schedule.dayOn(tuesday)?.status, BookingDayStatus.full);
  });

  test('watching another staff member or week replaces every stream', () {
    final first = request(murat, fixtures.weekStart);
    cubit.watch(first);
    expect(availability.isWatched('murat'), isTrue);
    cubit.watch(request(ayse, fixtures.weekStart));
    expect(availability.isWatched('murat'), isFalse);
    expect(availability.isWatched('ayse'), isTrue);
    for (final date in first.dates) {
      expect(appointments.bookedSlots.isWatched(key(murat, date)), isFalse);
      expect(appointments.bookedSlots.isWatched(key(ayse, date)), isTrue);
    }
    final next = request(ayse, nextWeek);
    cubit.watch(next);
    for (final date in first.dates) {
      expect(appointments.bookedSlots.isWatched(key(ayse, date)), isFalse);
    }
    for (final date in next.dates) {
      expect(appointments.bookedSlots.isWatched(key(ayse, date)), isTrue);
    }
  });

  test('a failure cancels everything and retry watches again', () async {
    final week = request(murat, fixtures.weekStart);
    cubit.watch(week);
    appointments.bookedSlots.emitFailure(key(murat, week.dates.first));
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state, isA<StaffWeekScheduleFailure>());
    expect(availability.isWatched('murat'), isFalse);
    cubit.retry();
    expect(cubit.state, isA<StaffWeekScheduleLoading>());
    expect(availability.isWatched('murat'), isTrue);
  });

  test('an availability stream error fails the schedule', () async {
    cubit.watch(request(murat, fixtures.weekStart));
    availability.emitFailure('murat');
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state, isA<StaffWeekScheduleFailure>());
  });

  test('clear and close cancel every stream', () async {
    final week = request(murat, fixtures.weekStart);
    cubit.watch(week);
    cubit.clear();
    expect(cubit.state, isA<StaffWeekScheduleIdle>());
    expect(availability.isWatched('murat'), isFalse);
    cubit.watch(week);
    await cubit.close();
    expect(availability.isWatched('murat'), isFalse);
    for (final date in week.dates) {
      expect(appointments.bookedSlots.isWatched(key(murat, date)), isFalse);
    }
    cubit.watch(week);
    expect(availability.isWatched('murat'), isFalse);
  });
}
