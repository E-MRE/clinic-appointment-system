import 'package:clinic_appointment_system/core/constants/availability_constants.dart';
import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window_visitor.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';

/// A window recurring every week on a single weekday.
final class WeeklyWindow extends AvailabilityWindow {
  /// Creates a recurring window.
  const WeeklyWindow({required this.weekday, required super.range});

  /// The recurring weekday.
  @override
  final Weekday weekday;

  /// Whether [day] is the recurring weekday.
  @override
  bool fallsOnWeekday(Weekday day) => day == weekday;

  /// Whether [date] has the recurring weekday.
  @override
  bool fallsOnDate(CalendarDate date) => date.weekday == weekday;

  /// Whether [other] can fall on this recurring weekday.
  @override
  bool sharesDayWith(AvailabilityWindow other) => other.fallsOnWeekday(weekday);

  /// Recurring windows never expire.
  @override
  bool hasExpiredBy(CalendarDate today) => false;

  /// Whether this weekday has already reached its recurring-window cap.
  @override
  bool exceedsLimitIn(StaffAvailability availability) {
    return availability.weeklyOn(weekday).length >=
        AvailabilityConstants.maxWindowsPerDay;
  }

  /// Copies the aggregate with this recurring window appended.
  @override
  StaffAvailability addTo(StaffAvailability availability) {
    return availability.withWeekly([...availability.weekly, this]);
  }

  /// Copies the aggregate excluding this recurring window by value.
  @override
  StaffAvailability removeFrom(StaffAvailability availability) {
    return availability.withWeekly(
      availability.weekly.where((window) => window != this),
    );
  }

  /// Dispatches to the recurring-window operation.
  @override
  R accept<R>(AvailabilityWindowVisitor<R> visitor) =>
      visitor.visitWeekly(this);

  /// The weekday and time range defining value identity.
  @override
  List<Object> get props => [weekday, range];
}
