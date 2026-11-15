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
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_week_schedule.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_week_schedule_request.dart';

/// Generates a staff member's bookable week from availability and booked slots.
final class StaffWeekScheduleFactory {
  /// Injects the shared slot-splitting policy.
  const StaffWeekScheduleFactory(this._generator);

  final SlotGenerator _generator;

  /// Generates upcoming slots for each requested date and availability window.
  StaffWeekSchedule create({
    required StaffWeekScheduleRequest request,
    required StaffAvailability availability,
    required List<BookedSlot> bookedSlots,
    required DateTime now,
  }) {
    final exclusion = BookedSlotExclusion(bookedSlots);
    final days = <StaffScheduleDay>[];
    for (final date in request.dates) {
      days.add(
        StaffScheduleDay(
          date: date,
          groups: _groupsFor(date, request, availability, exclusion, now),
        ),
      );
    }
    return StaffWeekSchedule(
      request: request,
      availability: availability,
      days: List<StaffScheduleDay>.unmodifiable(days),
    );
  }

  List<StaffSlotGroup> _groupsFor(
    CalendarDate date,
    StaffWeekScheduleRequest request,
    StaffAvailability availability,
    BookedSlotExclusion exclusion,
    DateTime now,
  ) {
    final groups = <StaffSlotGroup>[];
    for (final window in availability.effectiveWindowsOn(
      date,
      request.branchHours,
    )) {
      final slots = _upcomingSlots(window.range, date, request, exclusion, now);
      if (slots.isNotEmpty) {
        groups.add(StaffSlotGroup(window: window.range, slots: slots));
      }
    }
    return groups;
  }

  List<StaffSlot> _upcomingSlots(
    TimeRange window,
    CalendarDate date,
    StaffWeekScheduleRequest request,
    BookedSlotExclusion exclusion,
    DateTime now,
  ) {
    final slots = <StaffSlot>[];
    for (final range in _generator.split(window, request.service.duration)) {
      final start = date.atMinutes(range.start.minutesSinceMidnight);
      if (start.isBefore(now)) continue;
      slots.add(
        StaffSlot(range: range, isTaken: exclusion.excludes(date, range)),
      );
    }
    return slots;
  }
}
