import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';

/// Specifies the date and optional branch included in dashboard figures.
final class AdminDashboardScope {
  /// Creates a dashboard scope for [today] and an optional [branchId].
  const AdminDashboardScope({required this.today, this.branchId});

  /// The date used for today's and upcoming appointment selection.
  final CalendarDate today;

  /// The selected branch, or null when every branch is included.
  final String? branchId;

  /// Whether [appointment] is on [today] and within this branch scope.
  bool includesToday(Appointment appointment) {
    return appointment.date == today && _includesBranch(appointment);
  }

  /// Whether [appointment] is pending, dated today or later, and in scope.
  bool includesUpcomingPending(Appointment appointment) {
    return appointment.status == AppointmentStatus.pending &&
        !appointment.date.isBefore(today) &&
        _includesBranch(appointment);
  }

  bool _includesBranch(Appointment appointment) {
    if (branchId == null) return true;
    return appointment.branchId == branchId;
  }
}
