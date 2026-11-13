import 'package:clinic_appointment_system/core/constants/staff_calendar_constants.dart';
import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_calendar_day.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_calendar_layout.dart';

/// Factory that builds [StaffCalendarLayout] instances from visible dates,
/// appointments, availability, and branch hours.
final class StaffCalendarLayoutFactory {
  /// Creates the factory.
  const StaffCalendarLayoutFactory();

  /// Computes the calendar layout from visible dates, schedule data, and the current time.
  StaffCalendarLayout create({
    required List<CalendarDate> visibleDates,
    required Iterable<Appointment> appointments,
    required StaffAvailability availability,
    required WorkingHours branchHours,
    required DateTime now,
  }) {
    final filteredDates = _filterVisibleDates(visibleDates, branchHours);
    final days = filteredDates
        .map((date) {
          return _mapCalendarDate(
            branchHours,
            date,
            availability,
            appointments,
          );
        })
        .toList(growable: false);

    final openRanges = <TimeRange>[
      for (final day in days) ...branchHours.rangesOn(day.date.weekday),
    ];

    final int startHour;
    final int endHour;
    if (openRanges.isEmpty) {
      startHour = StaffCalendarConstants.defaultStartHour;
      endHour = StaffCalendarConstants.defaultEndHour;
    } else {
      final earliestStart = openRanges
          .map((range) => range.start)
          .reduce((first, second) => first.isBefore(second) ? first : second);
      final latestEnd = openRanges
          .map((range) => range.end)
          .reduce((first, second) => first.isAfter(second) ? first : second);

      startHour = earliestStart.hour;
      endHour = latestEnd.minute == 0 ? latestEnd.hour : latestEnd.hour + 1;
    }

    return StaffCalendarLayout(
      days: days,
      startHour: startHour,
      endHour: endHour,
      now: now,
    );
  }

  static List<CalendarDate> _filterVisibleDates(
    List<CalendarDate> dates,
    WorkingHours branchHours,
  ) {
    if (dates.length <= 1) {
      return dates;
    }
    if (!branchHours.isClosedOn(Weekday.sunday)) {
      return dates;
    }
    return dates
        .where((date) => date.weekday != Weekday.sunday)
        .toList(growable: false);
  }

  static StaffCalendarDay _mapCalendarDate(
    WorkingHours branchHours,
    CalendarDate date,
    StaffAvailability availability,
    Iterable<Appointment> appointments,
  ) {
    final isClosed = branchHours.isClosedOn(date.weekday);
    final bands = availability
        .effectiveWindowsOn(date, branchHours)
        .map((window) => window.range)
        .toList();
    final dayAppointments =
        appointments.where((appointment) => appointment.date == date).toList()
          ..sort((a, b) => a.range.start.compareTo(b.range.start));

    return StaffCalendarDay(
      date: date,
      isClosed: isClosed,
      availabilityBands: bands,
      appointments: dayAppointments,
    );
  }
}
