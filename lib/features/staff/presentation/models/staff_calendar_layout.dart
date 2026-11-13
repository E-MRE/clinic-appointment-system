import 'package:clinic_appointment_system/core/constants/clock_constants.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_calendar_day.dart';
import 'package:equatable/equatable.dart';

/// Computed layout model mapping appointments, availability, and branch hours
/// onto the visible staff calendar columns.
final class StaffCalendarLayout extends Equatable {
  /// Creates a staff calendar layout model.
  const StaffCalendarLayout({
    required this.days,
    required this.startHour,
    required this.endHour,
    required DateTime now,
  }) : _now = now;

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

  /// Converts a [range] to a 0..1 fraction representing its vertical height
  /// relative to the full calendar axis span ([startHour]..[endHour]).
  double heightFractionOf(TimeRange range) {
    return fractionOf(range.end) - fractionOf(range.start);
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

  @override
  List<Object?> get props => [days, startHour, endHour, _now];
}
