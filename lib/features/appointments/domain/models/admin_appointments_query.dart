import 'package:clinic_appointment_system/core/time/calendar_date.dart';

/// Inclusive date bounds for the administrator's appointment list.
final class AdminAppointmentsQuery {
  /// Captures both dates included in the administrator's list.
  const AdminAppointmentsQuery({required this.from, required this.through});

  /// The first included date.
  final CalendarDate from;

  /// The last included date.
  final CalendarDate through;
}
