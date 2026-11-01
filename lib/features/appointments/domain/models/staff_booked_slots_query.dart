import 'package:clinic_appointment_system/core/time/calendar_date.dart';

/// Identifies the patient-free daily projection needed by slot picking.
final class StaffBookedSlotsQuery {
  /// Captures the staff member and calendar date to observe.
  const StaffBookedSlotsQuery({required this.staffId, required this.date});

  final String staffId;
  final CalendarDate date;
}
