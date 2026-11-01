import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';

/// Calendar-date access using the instant supplied by a clock.
extension ClockToday on Clock {
  /// Today's date in the supplied instant's timezone, discarding time of day.
  CalendarDate get today => CalendarDate.fromDateTime(now());
}
