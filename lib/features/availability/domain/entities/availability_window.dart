import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window_visitor.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:equatable/equatable.dart';

/// A staff time window with shared conflict and branch-hours checks.
/// Subclasses must supply recurrence, expiry, limits and double dispatch.
abstract base class AvailabilityWindow extends Equatable {
  /// Creates a window over a half-open time range.
  const AvailabilityWindow({required this.range});

  /// The inclusive start and exclusive end of the available time.
  final TimeRange range;

  /// Subclasses must provide the weekday on which the window applies.
  Weekday get weekday;

  /// Subclasses must report whether the window can fall on [day].
  bool fallsOnWeekday(Weekday day);

  /// Subclasses must report whether the window applies to [date].
  bool fallsOnDate(CalendarDate date);

  /// Subclasses must determine whether [other] can share a calendar day.
  bool sharesDayWith(AvailabilityWindow other);

  /// Subclasses must report whether this window has expired before [today].
  bool hasExpiredBy(CalendarDate today);

  /// Subclasses must report whether adding this window would exceed its cap.
  bool exceedsLimitIn(StaffAvailability availability);

  /// Subclasses must copy [availability] with this window in its typed list.
  StaffAvailability addTo(StaffAvailability availability);

  /// Subclasses must copy [availability] without this window in its typed list.
  StaffAvailability removeFrom(StaffAvailability availability);

  /// Subclasses must dispatch to their corresponding method on [visitor].
  R accept<R>(AvailabilityWindowVisitor<R> visitor);

  /// Whether the windows overlap in time on a shared calendar day.
  bool conflictsWith(AvailabilityWindow other) =>
      sharesDayWith(other) && range.overlaps(other.range);

  /// Whether one branch range on this weekday entirely encloses this window.
  bool fitsWithin(WorkingHours hours) {
    return hours.rangesOn(weekday).any((opening) => opening.encloses(range));
  }
}
