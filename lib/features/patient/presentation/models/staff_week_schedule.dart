import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/services/booked_slot_exclusion.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/services/slot_generator.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/calendar_date_week.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_schedule_day.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_slot.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_slot_group.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_week_schedule_request.dart';

/// A staff member's bookable week: per listed day, the upcoming slots of
/// each effective availability window, each marked free or taken.
/// Slots starting before [now] are dropped; the boundary instant is kept.
final class StaffWeekSchedule {
  /// Splits every effective window of the requested week into service-length
  /// slots and marks those [bookedSlots] overlap as taken.
  factory StaffWeekSchedule({
    required StaffWeekScheduleRequest request,
    required StaffAvailability availability,
    required List<BookedSlot> bookedSlots,
    required DateTime now,
    SlotGenerator generator = const SlotGenerator(),
  }) {
    final exclusion = BookedSlotExclusion(bookedSlots);
    final days = [
      for (final date in request.dates)
        StaffScheduleDay(
          date: date,
          groups: [
            for (final window in availability.effectiveWindowsOn(
              date,
              request.branchHours,
            ))
              if (_upcomingSlots(
                    window.range,
                    date,
                    request,
                    generator,
                    exclusion,
                    now,
                  )
                  case final List<StaffSlot> slots when slots.isNotEmpty)
                StaffSlotGroup(window: window.range, slots: slots),
          ],
        ),
    ];
    return StaffWeekSchedule._(request, availability, days);
  }

  StaffWeekSchedule._(
    this.request,
    this.availability,
    List<StaffScheduleDay> days,
  ) : days = List<StaffScheduleDay>.unmodifiable(days);

  /// The staff member, service, week and branch hours this schedule shows.
  final StaffWeekScheduleRequest request;

  /// The staff member's availability the slots were generated from.
  final StaffAvailability availability;

  /// The listed days in date order.
  final List<StaffScheduleDay> days;

  /// The listed day on [date], or null when the date is not listed.
  StaffScheduleDay? dayOn(CalendarDate date) {
    for (final day in days) {
      if (day.date == date) return day;
    }
    return null;
  }

  /// The earliest day with a free slot, or null when the week is booked out.
  StaffScheduleDay? get firstAvailableDay {
    for (final day in days) {
      if (day.isSelectable) return day;
    }
    return null;
  }

  /// Whether [range] on [date] is an upcoming free slot.
  bool isFree(CalendarDate date, TimeRange range) {
    return dayOn(date)?.isFree(range) ?? false;
  }

  static List<StaffSlot> _upcomingSlots(
    TimeRange window,
    CalendarDate date,
    StaffWeekScheduleRequest request,
    SlotGenerator generator,
    BookedSlotExclusion exclusion,
    DateTime now,
  ) {
    return [
      for (final range in generator.split(window, request.service.duration))
        if (!date.atMinutes(range.start.minutesSinceMidnight).isBefore(now))
          StaffSlot(range: range, isTaken: exclusion.excludes(date, range)),
    ];
  }
}
