import 'package:clinic_appointment_system/core/time/calendar_date.dart';

/// Calendar arithmetic helpers for navigating days and weeks in the staff calendar.
extension StaffCalendarDateRange on CalendarDate {
  static const int _daysInWeek = 7;

  /// The date [days] calendar days later; negative values go back.
  CalendarDate addDays(int days) {
    return CalendarDate.fromDateTime(DateTime.utc(year, month, day + days));
  }

  /// The Monday of this date's week.
  CalendarDate get weekStart => addDays(-weekday.index);

  /// The seven dates of this date's Monday-through-Sunday week.
  List<CalendarDate> get weekDates {
    final start = weekStart;
    return List<CalendarDate>.generate(
      _daysInWeek,
      (index) => start.addDays(index),
      growable: false,
    );
  }

  /// Local midnight of this date, for date formatting.
  DateTime get startOfDay => DateTime(year, month, day);
}
