import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/patient/presentation/enums/day_period.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/clock_time_day_period.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_slot.dart';

/// The upcoming slots generated from one availability window.
final class StaffSlotGroup {
  /// Creates a group of [slots] inside [window].
  StaffSlotGroup({required this.window, required List<StaffSlot> slots})
    : slots = List<StaffSlot>.unmodifiable(slots);

  /// The effective availability window.
  final TimeRange window;

  /// Upcoming slots in start order.
  final List<StaffSlot> slots;

  /// The part of the day the window starts in.
  DayPeriod get period => window.start.dayPeriod;
}
