import 'package:clinic_appointment_system/core/time/calendar_date.dart';

/// Inclusive date bounds for a staff member's appointment list.
final class StaffAppointmentsQuery {
  /// Captures the assigned staff member and both included dates.
  const StaffAppointmentsQuery({
    required this.staffId,
    required this.from,
    required this.through,
  });

  final String staffId;
  final CalendarDate from;
  final CalendarDate through;
}
