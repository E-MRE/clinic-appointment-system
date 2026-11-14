import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_schedule_day.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_week_schedule.dart';

/// Reads date and slot selections from an already-generated staff schedule.
final class StaffWeekScheduleReader {
  /// Creates a stateless schedule reader.
  const StaffWeekScheduleReader();

  /// Returns the listed day on [date], or null when it is not listed.
  StaffScheduleDay? dayOn(StaffWeekSchedule schedule, CalendarDate date) {
    for (final day in schedule.days) {
      if (day.date == date) return day;
    }
    return null;
  }

  /// Returns the earliest day with a free slot, or null when all are full.
  StaffScheduleDay? firstAvailableDay(StaffWeekSchedule schedule) {
    for (final day in schedule.days) {
      if (day.isSelectable) return day;
    }
    return null;
  }

  /// Whether [range] on [date] is an upcoming free slot in [schedule].
  bool isFree(StaffWeekSchedule schedule, CalendarDate date, TimeRange range) {
    return dayOn(schedule, date)?.isFree(range) ?? false;
  }
}
