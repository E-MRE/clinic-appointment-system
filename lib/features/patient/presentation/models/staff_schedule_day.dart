import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/patient/presentation/enums/booking_day_status.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_slot.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_slot_group.dart';

/// One listed day of a staff member's booking week.
final class StaffScheduleDay {
  /// Creates a day holding its window [groups].
  StaffScheduleDay({required this.date, required List<StaffSlotGroup> groups})
    : groups = List<StaffSlotGroup>.unmodifiable(groups);

  /// The calendar date.
  final CalendarDate date;

  /// Window groups with at least one upcoming slot, in start order.
  final List<StaffSlotGroup> groups;

  /// Every upcoming slot of the day.
  Iterable<StaffSlot> get slots {
    return groups.expand((StaffSlotGroup group) => group.slots);
  }

  /// The number of upcoming free slots.
  int get freeCount => slots.where((StaffSlot slot) => slot.isFree).length;

  /// Closed without upcoming slots, full when all are taken.
  BookingDayStatus get status {
    if (slots.isEmpty) return BookingDayStatus.closed;
    if (slots.every((StaffSlot slot) => slot.isTaken)) {
      return BookingDayStatus.full;
    }
    return BookingDayStatus.available;
  }

  /// Whether the day can be chosen.
  bool get isSelectable => status == BookingDayStatus.available;

  /// Whether [range] is an upcoming free slot of the day.
  bool isFree(TimeRange range) {
    return slots.any((StaffSlot slot) => slot.range == range && slot.isFree);
  }
}
