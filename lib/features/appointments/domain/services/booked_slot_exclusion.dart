import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';
import 'package:clinic_appointment_system/features/availability/domain/services/slot_exclusion.dart';

/// Filters generated ranges against occupied slots.
final class BookedSlotExclusion implements SlotExclusion {
  /// Copies the slots used for filtering.
  BookedSlotExclusion(List<BookedSlot> slots)
    : slots = List<BookedSlot>.unmodifiable(slots);

  /// The slots considered by this exclusion.
  final List<BookedSlot> slots;

  /// Whether an occupied appointment on the date overlaps the slot.
  @override
  bool excludes(CalendarDate date, TimeRange candidate) =>
      slots.any((slot) => slot.date == date && slot.range.overlaps(candidate));
}
