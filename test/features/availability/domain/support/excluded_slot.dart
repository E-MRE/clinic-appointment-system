import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/availability/domain/services/slot_exclusion.dart';

/// Removes exactly one date and range through the appointment exclusion seam.
final class ExcludedSlot implements SlotExclusion {
  /// Creates an exclusion for a single booked slot.
  const ExcludedSlot({required this.date, required this.slot});

  /// The appointment's date.
  final CalendarDate date;

  /// The appointment's time range.
  final TimeRange slot;

  /// Whether this is the one excluded date and range.
  @override
  bool excludes(CalendarDate date, TimeRange slot) {
    return date == this.date && slot == this.slot;
  }
}
