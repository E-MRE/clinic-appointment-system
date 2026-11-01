import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/availability/domain/services/slot_exclusion.dart';

/// Filters slots occupied by existing appointments.
final class BookedSlotExclusion implements SlotExclusion {
  /// Copies the appointments used for filtering.
  BookedSlotExclusion(List<Appointment> appointments)
    : appointments = List<Appointment>.unmodifiable(appointments);

  /// The appointments considered by this exclusion.
  final List<Appointment> appointments;

  /// Whether an occupied appointment on the date overlaps the slot.
  @override
  bool excludes(CalendarDate date, TimeRange slot) => appointments.any(
    (appointment) =>
        appointment.date == date &&
        appointment.occupiesSlot &&
        appointment.range.overlaps(slot),
  );
}
