import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/services/appointment_start_comparator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/appointment_fixture.dart';

void main() {
  const fixture = AppointmentFixture();
  const comparator = AppointmentStartComparator();

  test('orders by date, start time, then id', () {
    final laterDate = _appointment(
      fixture,
      id: 'a',
      date: CalendarDate(year: 2026, month: 11, day: 15),
      startMinutes: 480,
    );
    final laterStart = _appointment(
      fixture,
      id: 'a',
      date: fixture.date,
      startMinutes: 600,
    );
    final idB = _appointment(
      fixture,
      id: 'b',
      date: fixture.date,
      startMinutes: 540,
    );
    final idA = _appointment(
      fixture,
      id: 'a',
      date: fixture.date,
      startMinutes: 540,
    );

    final appointments = [laterDate, laterStart, idB, idA]
      ..sort(comparator.call);

    expect(appointments, [idA, idB, laterStart, laterDate]);
    expect(comparator(idA, idA), 0);
  });

  test('orders by start time in both directions and leaves ties equal', () {
    final laterStart = _appointment(
      fixture,
      id: 'later',
      date: fixture.date,
      startMinutes: 600,
    );
    final sameStartB = _appointment(
      fixture,
      id: 'b',
      date: fixture.date,
      startMinutes: 540,
    );
    final sameStartA = _appointment(
      fixture,
      id: 'a',
      date: fixture.date,
      startMinutes: 540,
    );

    final ascending = [laterStart, sameStartB, sameStartA]
      ..sort(comparator.compareByStartTime);
    final descending = [sameStartA, sameStartB, laterStart]
      ..sort(comparator.compareByStartTimeDescending);

    expect(ascending.first.startsAt, sameStartA.startsAt);
    expect(ascending.last, laterStart);
    expect(descending.first, laterStart);
    expect(descending.last.startsAt, sameStartA.startsAt);
    expect(comparator.compareByStartTime(sameStartA, sameStartB), 0);
    expect(comparator.compareByStartTimeDescending(sameStartA, sameStartB), 0);
  });
}

Appointment _appointment(
  AppointmentFixture fixture, {
  required String id,
  required CalendarDate date,
  required int startMinutes,
}) {
  return Appointment.restore(
    id: id,
    patientId: 'patient',
    patientName: 'Patient',
    staffId: 'staff',
    branchId: 'branch',
    departmentId: 'department',
    serviceId: 'service',
    serviceName: 'Service',
    fee: fixture.fee,
    date: date,
    range: TimeRange(
      start: ClockTime.fromMinutes(startMinutes),
      end: ClockTime.fromMinutes(startMinutes + 30),
    ),
    status: AppointmentStatus.pending,
    history: [fixture.change(AppointmentStatus.pending)],
  );
}
