import 'package:clinic_appointment_system/core/constants/availability_constants.dart';
import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window_visitor.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';

/// An extra window applying only to one calendar date.
final class OneOffWindow extends AvailabilityWindow {
  /// Creates a dated extra window.
  const OneOffWindow({required this.date, required super.range});

  /// The sole date on which this window applies.
  final CalendarDate date;

  /// The weekday of the window's date.
  @override
  Weekday get weekday => date.weekday;

  /// Whether the window's date falls on [day].
  @override
  bool fallsOnWeekday(Weekday day) => date.weekday == day;

  /// Whether [date] is the window's sole date.
  @override
  bool fallsOnDate(CalendarDate date) => date == this.date;

  /// Whether [other] applies to this window's date.
  @override
  bool sharesDayWith(AvailabilityWindow other) => other.fallsOnDate(date);

  /// Whether the window's date precedes [today].
  @override
  bool hasExpiredBy(CalendarDate today) => date.isBefore(today);

  /// Whether the schedule has already reached its dated-window cap.
  @override
  bool exceedsLimitIn(StaffAvailability availability) {
    return availability.oneOff.length >= AvailabilityConstants.maxOneOffWindows;
  }

  /// Copies the aggregate with this dated window appended.
  @override
  StaffAvailability addTo(StaffAvailability availability) {
    return availability.withOneOff([...availability.oneOff, this]);
  }

  /// Copies the aggregate excluding this dated window by value.
  @override
  StaffAvailability removeFrom(StaffAvailability availability) {
    return availability.withOneOff(
      availability.oneOff.where((window) => window != this),
    );
  }

  /// Dispatches to the dated-window operation.
  @override
  R accept<R>(AvailabilityWindowVisitor<R> visitor) =>
      visitor.visitOneOff(this);

  /// The date and time range defining value identity.
  @override
  List<Object> get props => [date, range];
}
