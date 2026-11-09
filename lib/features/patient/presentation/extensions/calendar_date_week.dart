import 'package:clinic_appointment_system/core/time/calendar_date.dart';

/// Day arithmetic the booking week needs on a [CalendarDate].
extension CalendarDateWeek on CalendarDate {
  /// The date [days] calendar days later; negative values go back.
  CalendarDate addDays(int days) {
    return CalendarDate.fromDateTime(DateTime.utc(year, month, day + days));
  }

  /// The Monday of this date's week.
  CalendarDate get weekStart => addDays(-weekday.index);

  /// Local midnight of this date, for date formatting.
  DateTime get startOfDay => DateTime(year, month, day);

  /// The local instant [minutes] after midnight on this date.
  DateTime atMinutes(int minutes) => DateTime(year, month, day, 0, minutes);
}
