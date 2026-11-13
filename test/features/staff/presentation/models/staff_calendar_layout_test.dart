import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/appointment_status_change.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_calendar_day.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_calendar_layout.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

Appointment _makeAppointment({
  required String id,
  required CalendarDate date,
  required ClockTime start,
  required ClockTime end,
}) {
  return Appointment.restore(
    id: id,
    patientId: 'patient_$id',
    patientName: 'Hasta $id',
    staffId: 'staff_1',
    branchId: 'branch_1',
    departmentId: 'dept_1',
    serviceId: 'srv_1',
    serviceName: 'Muayene',
    fee: Money.minorUnits(10000),
    date: date,
    range: TimeRange(start: start, end: end),
    status: AppointmentStatus.approved,
    history: [
      AppointmentStatusChange(
        status: AppointmentStatus.approved,
        byUserId: 'staff_1',
        byRole: UserRole.doctor,
        at: DateTime.utc(2026, 10, 20, 8),
      ),
    ],
  );
}

void main() {
  group('StaffCalendarLayout', () {
    final monday = CalendarDate(year: 2026, month: 10, day: 26);
    final tuesday = CalendarDate(year: 2026, month: 10, day: 27);

    test('fractionOf converts time to 0..1 fraction of the visible range', () {
      final layout = StaffCalendarLayout(
        days: [
          StaffCalendarDay(
            date: monday,
            isClosed: false,
            availabilityBands: const [],
            appointments: const [],
          ),
        ],
        startHour: 8,
        endHour: 18,
        now: DateTime(2026, 10, 26, 10),
      );

      // Range is 08:00–18:00 (10 hours = 600 min)
      expect(layout.fractionOf(ClockTime(hour: 8, minute: 0)), 0.0);
      expect(layout.fractionOf(ClockTime(hour: 13, minute: 0)), 0.5);
      expect(layout.fractionOf(ClockTime(hour: 18, minute: 0)), 1.0);
    });

    test('heightFractionOf converts range to height delta', () {
      final layout = StaffCalendarLayout(
        days: [
          StaffCalendarDay(
            date: monday,
            isClosed: false,
            availabilityBands: const [],
            appointments: const [],
          ),
        ],
        startHour: 8,
        endHour: 18,
        now: DateTime(2026, 10, 26, 10),
      );

      final range = TimeRange(
        start: ClockTime(hour: 9, minute: 0),
        end: ClockTime(hour: 10, minute: 0),
      );

      // 1 hour out of 10 hours = 0.1
      expect(layout.heightFractionOf(range), closeTo(0.1, 0.001));
    });

    test(
      'nowFraction is computed when now is inside range on a visible day',
      () {
        final layout = StaffCalendarLayout(
          days: [
            StaffCalendarDay(
              date: monday,
              isClosed: false,
              availabilityBands: const [],
              appointments: const [],
            ),
          ],
          startHour: 8,
          endHour: 18,
          now: DateTime(2026, 10, 26, 10, 30),
        );

        // 10:30 is 150 minutes past 08:00 => 150 / 600 = 0.25
        expect(layout.nowFraction, closeTo(0.25, 0.001));
      },
    );

    test('nowFraction is null when now falls outside the hour range', () {
      final layoutEarly = StaffCalendarLayout(
        days: [
          StaffCalendarDay(
            date: monday,
            isClosed: false,
            availabilityBands: const [],
            appointments: const [],
          ),
        ],
        startHour: 8,
        endHour: 18,
        now: DateTime(2026, 10, 26, 7, 30),
      );
      expect(layoutEarly.nowFraction, isNull);

      final layoutLate = StaffCalendarLayout(
        days: [
          StaffCalendarDay(
            date: monday,
            isClosed: false,
            availabilityBands: const [],
            appointments: const [],
          ),
        ],
        startHour: 8,
        endHour: 18,
        now: DateTime(2026, 10, 26, 18, 30),
      );
      expect(layoutLate.nowFraction, isNull);
    });

    test('nowFraction is null when today is not in visible days', () {
      final layout = StaffCalendarLayout(
        days: [
          StaffCalendarDay(
            date: monday,
            isClosed: false,
            availabilityBands: const [],
            appointments: const [],
          ),
        ],
        startHour: 8,
        endHour: 18,
        now: DateTime(2026, 10, 27, 10, 30),
      );

      expect(layout.nowFraction, isNull);
    });

    test('weekAppointmentCount sums appointment counts across days', () {
      final appt1 = _makeAppointment(
        id: '1',
        date: monday,
        start: ClockTime(hour: 9, minute: 0),
        end: ClockTime(hour: 9, minute: 30),
      );
      final appt2 = _makeAppointment(
        id: '2',
        date: monday,
        start: ClockTime(hour: 10, minute: 0),
        end: ClockTime(hour: 10, minute: 30),
      );
      final appt3 = _makeAppointment(
        id: '3',
        date: tuesday,
        start: ClockTime(hour: 11, minute: 0),
        end: ClockTime(hour: 11, minute: 30),
      );

      final layout = StaffCalendarLayout(
        days: [
          StaffCalendarDay(
            date: monday,
            isClosed: false,
            availabilityBands: const [],
            appointments: [appt1, appt2],
          ),
          StaffCalendarDay(
            date: tuesday,
            isClosed: false,
            availabilityBands: const [],
            appointments: [appt3],
          ),
        ],
        startHour: 8,
        endHour: 18,
        now: DateTime(2026, 10, 26, 10),
      );

      expect(layout.weekAppointmentCount, 3);
    });

    test('equality and props contain days, startHour, endHour, and now', () {
      final now = DateTime(2026, 10, 26, 10);
      final day = StaffCalendarDay(
        date: monday,
        isClosed: false,
        availabilityBands: const [],
        appointments: const [],
      );

      final layoutA = StaffCalendarLayout(
        days: [day],
        startHour: 8,
        endHour: 18,
        now: now,
      );
      final layoutB = StaffCalendarLayout(
        days: [day],
        startHour: 8,
        endHour: 18,
        now: now,
      );

      expect(layoutA, equals(layoutB));
      expect(layoutA.props, [
        [day],
        8,
        18,
        now,
      ]);
    });
  });
}
