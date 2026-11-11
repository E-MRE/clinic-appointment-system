import 'package:clinic_appointment_system/core/constants/clock_constants.dart';
import 'package:clinic_appointment_system/core/constants/staff_calendar_constants.dart';
import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_calendar_day.dart';
import 'package:equatable/equatable.dart';

/// Computed layout model mapping appointments, availability, and branch hours
/// onto the visible staff calendar columns.
final class StaffCalendarLayout extends Equatable {
  /// Computes the calendar layout from visible dates, schedule data, and the current time.
  factory StaffCalendarLayout({
    required List<CalendarDate> visibleDates,
    required Iterable<Appointment> appointments,
    required StaffAvailability availability,
    required WorkingHours branchHours,
    required DateTime now,
  }) {
    final filteredDates = _filterVisibleDates(visibleDates, branchHours);
    final days = filteredDates
        .map((date) {
          final isClosed = branchHours.isClosedOn(date.weekday);
          final bands = availability
              .effectiveWindowsOn(date, branchHours)
              .map((window) => window.range)
              .toList();
          final dayAppointments =
              appointments
                  .where((appointment) => appointment.date == date)
                  .toList()
                ..sort((a, b) => a.range.start.compareTo(b.range.start));

          return StaffCalendarDay(
            date: date,
            isClosed: isClosed,
            availabilityBands: bands,
            appointments: dayAppointments,
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

    return StaffCalendarLayout._(
      days: days,
      startHour: startHour,
      endHour: endHour,
      now: now,
    );
  }

  const StaffCalendarLayout._({
    required this.days,
    required this.startHour,
    required this.endHour,
    required DateTime now,
  }) : _now = now;

  static const int _singleDayCount = 1;

  /// The visible day columns, omitting Sunday when closed in week view.
  final List<StaffCalendarDay> days;

  /// Earliest whole hour covering branch opening across visible days.
  final int startHour;

  /// Latest whole hour covering branch closing across visible days.
  final int endHour;

  final DateTime _now;

  /// Position (0..1) of the current time on today's column, or null when
  /// today is not visible or the time is outside [startHour]..[endHour].
  double? get nowFraction {
    final today = CalendarDate.fromDateTime(_now);
    if (!days.any((day) => day.date == today)) return null;
    final minutes = _now.hour * ClockConstants.minutesPerHour + _now.minute;
    if (minutes < _startMinutes || minutes > _endMinutes) return null;
    return _fractionOfMinutes(minutes);
  }

  /// Converts a [time] to a 0..1 fraction within [startHour] and [endHour].
  double fractionOf(ClockTime time) {
    return _fractionOfMinutes(time.minutesSinceMidnight);
  }

  int get _startMinutes => startHour * ClockConstants.minutesPerHour;

  int get _endMinutes => endHour * ClockConstants.minutesPerHour;

  double _fractionOfMinutes(int minutes) {
    final total = _endMinutes - _startMinutes;
    if (total <= 0) return 0;
    return ((minutes - _startMinutes) / total).clamp(0.0, 1.0);
  }

  /// Total count of scheduled appointments across all visible days.
  int get weekAppointmentCount =>
      days.fold(0, (sum, day) => sum + day.appointmentCount);

  static List<CalendarDate> _filterVisibleDates(
    List<CalendarDate> dates,
    WorkingHours branchHours,
  ) {
    if (dates.length <= _singleDayCount) {
      return dates;
    }
    if (!branchHours.isClosedOn(Weekday.sunday)) {
      return dates;
    }
    return dates
        .where((date) => date.weekday != Weekday.sunday)
        .toList(growable: false);
  }

  @override
  List<Object?> get props => [days, startHour, endHour, _now];
}
