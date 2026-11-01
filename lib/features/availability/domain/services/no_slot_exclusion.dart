import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/availability/domain/services/slot_exclusion.dart';

/// Null Object that keeps every generated slot.
final class NoSlotExclusion implements SlotExclusion {
  /// Creates an exclusion that never filters a slot.
  const NoSlotExclusion();

  /// Always keeps the proposed slot.
  @override
  bool excludes(CalendarDate date, TimeRange slot) => false;
}
