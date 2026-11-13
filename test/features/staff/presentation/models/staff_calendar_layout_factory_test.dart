import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/appointment_status_change.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/weekly_window.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_calendar_date_range.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_calendar_layout_factory.dart';
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
  group('StaffCalendarLayoutFactory', () {
    const factory = StaffCalendarLayoutFactory();
    // Mon 2026-10-26 .. Sun 2026-11-01
    final monday = CalendarDate(year: 2026, month: 10, day: 26);
    final weekDates = List<CalendarDate>.generate(7, (i) => monday.addDays(i));

    final availability = StaffAvailability(
      staffId: 'staff_1',
      branchId: 'branch_1',
      weekly: [
        WeeklyWindow(
          weekday: Weekday.monday,
          range: TimeRange(
            start: ClockTime(hour: 9, minute: 0),
            end: ClockTime(hour: 12, minute: 0),
          ),
        ),
      ],
    );

    test(
      'computes hour range from branch hours with floor start and ceil end',
      () {
        final hours = WorkingHours({
          Weekday.monday: [
            TimeRange(
              start: ClockTime(hour: 8, minute: 30),
              end: ClockTime(hour: 17, minute: 30),
            ),
          ],
        });

        final layout = factory.create(
          visibleDates: weekDates,
          appointments: const [],
          availability: availability,
          branchHours: hours,
          now: DateTime.utc(2026, 10, 26, 10),
        );

        expect(layout.startHour, 8);
        expect(layout.endHour, 18);
      },
    );

    test('exact whole hour branch bounds stay unshifted', () {
      final hours = WorkingHours({
        Weekday.monday: [
          TimeRange(
            start: ClockTime(hour: 9, minute: 0),
            end: ClockTime(hour: 17, minute: 0),
          ),
        ],
      });

      final layout = factory.create(
        visibleDates: weekDates,
        appointments: const [],
        availability: availability,
        branchHours: hours,
        now: DateTime.utc(2026, 10, 26, 10),
      );

      expect(layout.startHour, 9);
      expect(layout.endHour, 17);
    });

    test(
      'falls back to default 08:00–18:00 when all visible days are closed',
      () {
        final layout = factory.create(
          visibleDates: weekDates,
          appointments: const [],
          availability: availability,
          branchHours: WorkingHours.closed(),
          now: DateTime.utc(2026, 10, 26, 10),
        );

        expect(layout.startHour, 8);
        expect(layout.endHour, 18);
      },
    );

    test('flags closed days accurately per day', () {
      final hours = WorkingHours({
        Weekday.monday: [
          TimeRange(
            start: ClockTime(hour: 9, minute: 0),
            end: ClockTime(hour: 17, minute: 0),
          ),
        ],
      });

      final layout = factory.create(
        visibleDates: weekDates,
        appointments: const [],
        availability: availability,
        branchHours: hours,
        now: DateTime.utc(2026, 10, 26, 10),
      );

      expect(layout.days.first.isClosed, isFalse);
      expect(layout.days[1].isClosed, isTrue);
    });

    test('drops closed Sunday in week view, keeps it when open', () {
      final closedSundayHours = WorkingHours({
        Weekday.monday: [
          TimeRange(
            start: ClockTime(hour: 9, minute: 0),
            end: ClockTime(hour: 17, minute: 0),
          ),
        ],
      });

      final layoutClosed = factory.create(
        visibleDates: weekDates,
        appointments: const [],
        availability: availability,
        branchHours: closedSundayHours,
        now: DateTime.utc(2026, 10, 26, 10),
      );

      expect(layoutClosed.days.length, 6);
      expect(
        layoutClosed.days.any((d) => d.date.weekday == Weekday.sunday),
        isFalse,
      );

      final openSundayHours = WorkingHours({
        Weekday.monday: [
          TimeRange(
            start: ClockTime(hour: 9, minute: 0),
            end: ClockTime(hour: 17, minute: 0),
          ),
        ],
        Weekday.sunday: [
          TimeRange(
            start: ClockTime(hour: 10, minute: 0),
            end: ClockTime(hour: 14, minute: 0),
          ),
        ],
      });

      final layoutOpen = factory.create(
        visibleDates: weekDates,
        appointments: const [],
        availability: availability,
        branchHours: openSundayHours,
        now: DateTime.utc(2026, 10, 26, 10),
      );

      expect(layoutOpen.days.length, 7);
      expect(layoutOpen.days.last.date.weekday, Weekday.sunday);
    });

    test('keeps single day in day view even when Sunday is closed', () {
      final sunday = CalendarDate(year: 2026, month: 11, day: 1);
      final layout = factory.create(
        visibleDates: [sunday],
        appointments: const [],
        availability: availability,
        branchHours: WorkingHours.closed(),
        now: DateTime.utc(2026, 11, 1, 10),
      );

      expect(layout.days.length, 1);
      expect(layout.days.first.date, sunday);
      expect(layout.days.first.isClosed, isTrue);
    });

    test('groups appointments by day and sorts them by start time', () {
      final mon = CalendarDate(year: 2026, month: 10, day: 26);
      final tue = CalendarDate(year: 2026, month: 10, day: 27);

      final apptLateMon = _makeAppointment(
        id: '1',
        date: mon,
        start: ClockTime(hour: 14, minute: 0),
        end: ClockTime(hour: 14, minute: 30),
      );
      final apptEarlyMon = _makeAppointment(
        id: '2',
        date: mon,
        start: ClockTime(hour: 9, minute: 30),
        end: ClockTime(hour: 10, minute: 0),
      );
      final apptTue = _makeAppointment(
        id: '3',
        date: tue,
        start: ClockTime(hour: 11, minute: 0),
        end: ClockTime(hour: 11, minute: 30),
      );

      final layout = factory.create(
        visibleDates: [mon, tue],
        appointments: [apptLateMon, apptTue, apptEarlyMon],
        availability: availability,
        branchHours: WorkingHours.closed(),
        now: DateTime.utc(2026, 10, 26, 10),
      );

      final mondayColumn = layout.days.first;
      expect(mondayColumn.appointmentCount, 2);
      expect(mondayColumn.appointments.first.id, '2');
      expect(mondayColumn.appointments.last.id, '1');

      final tuesdayColumn = layout.days[1];
      expect(tuesdayColumn.appointmentCount, 1);
      expect(tuesdayColumn.appointments.first.id, '3');

      expect(layout.weekAppointmentCount, 3);
    });

    test('populates availability bands per day from effective windows', () {
      final hours = WorkingHours({
        Weekday.monday: [
          TimeRange(
            start: ClockTime(hour: 8, minute: 0),
            end: ClockTime(hour: 17, minute: 0),
          ),
        ],
      });

      final layout = factory.create(
        visibleDates: weekDates,
        appointments: const [],
        availability: availability,
        branchHours: hours,
        now: DateTime.utc(2026, 10, 26, 10),
      );

      final mondayBands = layout.days.first.availabilityBands;
      expect(mondayBands.length, 1);
      expect(
        mondayBands.first,
        TimeRange(
          start: ClockTime(hour: 9, minute: 0),
          end: ClockTime(hour: 12, minute: 0),
        ),
      );

      final tuesdayBands = layout.days[1].availabilityBands;
      expect(tuesdayBands, isEmpty);
    });
  });
}
