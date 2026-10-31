import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';

/// Slot filtering boundary; issue #14 will exclude booked appointments here.
abstract interface class SlotExclusion {
  /// Implementations must report whether [slot] on [date] must be omitted.
  bool excludes(CalendarDate date, TimeRange slot);
}
