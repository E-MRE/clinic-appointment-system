import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/services/no_slot_exclusion.dart';
import 'package:clinic_appointment_system/features/availability/domain/services/slot_exclusion.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';

/// Produces complete, back-to-back slots inside effective staff windows.
final class SlotGenerator {
  /// Creates a stateless slot generator.
  const SlotGenerator();

  /// Splits [window] into complete slots, discarding an uneven remainder.
  /// Integer bounds are checked before constructing either clock endpoint.
  List<TimeRange> split(TimeRange window, ServiceDuration duration) {
    final slots = <TimeRange>[];
    final windowEnd = window.end.minutesSinceMidnight;
    int slotStart = window.start.minutesSinceMidnight;
    while (slotStart + duration.minutes <= windowEnd) {
      final slotEnd = slotStart + duration.minutes;
      slots.add(
        TimeRange(
          start: ClockTime.fromMinutes(slotStart),
          end: ClockTime.fromMinutes(slotEnd),
        ),
      );
      slotStart = slotEnd;
    }
    return slots;
  }

  /// Counts complete slots without constructing clock endpoints.
  int slotCount(TimeRange window, ServiceDuration duration) {
    return window.durationMinutes ~/ duration.minutes;
  }

  /// Generates slots in start order from windows fitting current branch hours.
  /// Omits every slot rejected by [exclusion], preserving gaps between windows.
  List<TimeRange> slotsFor({
    required StaffAvailability availability,
    required CalendarDate date,
    required ServiceDuration duration,
    required WorkingHours branchHours,
    SlotExclusion exclusion = const NoSlotExclusion(),
  }) {
    final slots = <TimeRange>[];
    for (final window in availability.effectiveWindowsOn(date, branchHours)) {
      for (final slot in split(window.range, duration)) {
        if (!exclusion.excludes(date, slot)) {
          slots.add(slot);
        }
      }
    }
    slots.sort((first, second) => first.start.compareTo(second.start));
    return slots;
  }
}
