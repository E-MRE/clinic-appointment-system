import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/one_off_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/weekly_window.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';

/// Worked calendar and time examples shared by availability tests.
final class AvailabilityFixture {
  /// Creates the test examples.
  const AvailabilityFixture();

  /// Monday, November 2, 2026.
  CalendarDate get monday => CalendarDate(year: 2026, month: 11, day: 2);

  /// Tuesday, November 3, 2026.
  CalendarDate get tuesday => CalendarDate(year: 2026, month: 11, day: 3);

  /// An empty staff schedule.
  StaffAvailability get empty =>
      StaffAvailability.empty(staffId: 'staff', branchId: 'branch');

  /// Branch hours with a lunch gap, closed on weekends.
  WorkingHours get hours {
    return WorkingHours({
      for (final day in [
        Weekday.monday,
        Weekday.tuesday,
        Weekday.wednesday,
        Weekday.thursday,
        Weekday.friday,
      ])
        day: [range(510, 720), range(780, 1080)],
    });
  }

  /// Creates a range from minutes since midnight.
  TimeRange range(int start, int end) {
    return TimeRange(
      start: ClockTime.fromMinutes(start),
      end: ClockTime.fromMinutes(end),
    );
  }

  /// Creates a recurring window, on Monday by default.
  WeeklyWindow weekly(int start, int end, {Weekday day = Weekday.monday}) {
    return WeeklyWindow(weekday: day, range: range(start, end));
  }

  /// Creates an extra window, on the example Monday by default.
  OneOffWindow oneOff(int start, int end, {CalendarDate? date}) {
    return OneOffWindow(date: date ?? monday, range: range(start, end));
  }
}
