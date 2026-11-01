import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/one_off_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/weekly_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:equatable/equatable.dart';

/// Immutable availability for a staff member at one branch.
/// Construction sorts and copies windows; the rule chain owns validation.
final class StaffAvailability extends Equatable {
  /// Copies and sorts windows without validating their business rules.
  factory StaffAvailability({
    required String staffId,
    required String branchId,
    Iterable<WeeklyWindow> weekly = const [],
    Iterable<OneOffWindow> oneOff = const [],
  }) {
    final sortedWeekly = List<WeeklyWindow>.of(weekly)
      ..sort((first, second) {
        final dayOrder = first.weekday.index.compareTo(second.weekday.index);
        if (dayOrder != _equalOrder) {
          return dayOrder;
        }
        return first.range.start.compareTo(second.range.start);
      });
    final sortedOneOff = List<OneOffWindow>.of(oneOff)
      ..sort((first, second) {
        final dateOrder = first.date.compareTo(second.date);
        if (dateOrder != _equalOrder) {
          return dateOrder;
        }
        return first.range.start.compareTo(second.range.start);
      });
    return StaffAvailability._(
      staffId: staffId,
      branchId: branchId,
      weekly: List<WeeklyWindow>.unmodifiable(sortedWeekly),
      oneOff: List<OneOffWindow>.unmodifiable(sortedOneOff),
    );
  }

  /// Creates an empty recurring week with no dated extra windows.
  factory StaffAvailability.empty({
    required String staffId,
    required String branchId,
  }) {
    return StaffAvailability(staffId: staffId, branchId: branchId);
  }

  const StaffAvailability._({
    required this.staffId,
    required this.branchId,
    required this.weekly,
    required this.oneOff,
  });

  static int get _equalOrder => 0;

  int get _noMinutes => 0;

  /// The staff profile identifier.
  final String staffId;

  /// The branch whose working hours constrain this schedule.
  final String branchId;

  /// Unmodifiable recurring windows sorted by weekday, then start.
  final List<WeeklyWindow> weekly;

  /// Unmodifiable dated windows sorted by date, then start.
  final List<OneOffWindow> oneOff;

  /// Copies this schedule with replacement recurring windows.
  StaffAvailability withWeekly(Iterable<WeeklyWindow> windows) {
    return StaffAvailability(
      staffId: staffId,
      branchId: branchId,
      weekly: windows,
      oneOff: oneOff,
    );
  }

  /// Copies this schedule with replacement dated extra windows.
  StaffAvailability withOneOff(Iterable<OneOffWindow> windows) {
    return StaffAvailability(
      staffId: staffId,
      branchId: branchId,
      weekly: weekly,
      oneOff: windows,
    );
  }

  /// Recurring windows on [day], sorted by start.
  List<WeeklyWindow> weeklyOn(Weekday day) {
    return weekly.where((window) => window.fallsOnWeekday(day)).toList();
  }

  /// Recurring and extra windows applying to [date], sorted by start.
  List<AvailabilityWindow> windowsOn(CalendarDate date) {
    return _sortedByStart([
      ...weekly.where((window) => window.fallsOnDate(date)),
      ...oneOff.where((window) => window.fallsOnDate(date)),
    ]);
  }

  /// Windows on [date] still enclosed by the branch's current hours.
  List<AvailabilityWindow> effectiveWindowsOn(
    CalendarDate date,
    WorkingHours branchHours,
  ) {
    return windowsOn(
      date,
    ).where((window) => window.fitsWithin(branchHours)).toList();
  }

  /// The first conflicting stored window in start order, or null.
  AvailabilityWindow? conflictOf(AvailabilityWindow candidate) {
    final sorted = _sortedByStart([...weekly, ...oneOff]);
    for (final window in sorted) {
      if (window.conflictsWith(candidate)) {
        return window;
      }
    }
    return null;
  }

  /// Adds a window through its typed double-dispatch operation.
  StaffAvailability adding(AvailabilityWindow window) => window.addTo(this);

  /// Removes a window by value through its typed double-dispatch operation.
  /// Throws [AvailabilityException] with windowNotFound when absent.
  StaffAvailability removing(AvailabilityWindow window) {
    if (!weekly.contains(window) && !oneOff.contains(window)) {
      throw const AvailabilityException(AvailabilityErrorCode.windowNotFound);
    }
    return window.removeFrom(this);
  }

  /// Drops expired dated windows while preserving recurring windows and today.
  StaffAvailability prunedBy(CalendarDate today) {
    return withOneOff(oneOff.where((window) => !window.hasExpiredBy(today)));
  }

  /// The total recurring minutes on [day], excluding dated extra windows.
  int minutesOn(Weekday day) {
    return weeklyOn(day).fold(
      _noMinutes,
      (minutes, window) => minutes + window.range.durationMinutes,
    );
  }

  /// The total recurring minutes over the entire week.
  int get weeklyMinutes {
    return Weekday.values.fold(
      _noMinutes,
      (minutes, day) => minutes + minutesOn(day),
    );
  }

  List<AvailabilityWindow> _sortedByStart(
    Iterable<AvailabilityWindow> windows,
  ) {
    return List<AvailabilityWindow>.of(
      windows,
    )..sort((first, second) => first.range.start.compareTo(second.range.start));
  }

  /// The subject identifiers and sorted window collections defining identity.
  @override
  List<Object> get props => [staffId, branchId, weekly, oneOff];
}
