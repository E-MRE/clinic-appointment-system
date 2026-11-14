import 'package:clinic_appointment_system/features/admin/presentation/models/admin_dashboard_department_row.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_dashboard_staff_row.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_dashboard_status_count.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:equatable/equatable.dart';

/// An immutable, branch-filtered snapshot of administrator dashboard figures.
final class AdminDashboardSummary extends Equatable {
  /// Creates a snapshot from already-calculated dashboard values.
  const AdminDashboardSummary({
    required this.selectedBranchId,
    required this.todayAppointmentCount,
    required this.distinctBranchCount,
    required this.distinctStaffCount,
    required this.pendingCount,
    required this.oldestPendingCreatedAt,
    required this.completedCount,
    required this.noShowCount,
    required this.statusCounts,
    required this.departmentRows,
    required this.staffRows,
    required this.pendingAppointments,
  });

  /// The selected branch, or null when the summary spans every branch.
  final String? selectedBranchId;

  /// The number of appointments on the observed date in the selected branch scope.
  final int todayAppointmentCount;

  /// The number of distinct branches represented among today's appointments.
  final int distinctBranchCount;

  /// The number of distinct staff members represented among today's appointments.
  final int distinctStaffCount;

  /// The pending requests dated today or later in the selected branch scope.
  final int pendingCount;

  /// The first history time of the oldest pending request, or null when empty.
  final DateTime? oldestPendingCreatedAt;

  /// The number of today's appointments in the completed status.
  final int completedCount;

  /// The number of today's appointments in the no-show status.
  final int noShowCount;

  /// Non-zero today's status counts in the dashboard's fixed display order.
  final List<AdminDashboardStatusCount> statusCounts;

  /// Today's department counts, sorted by count descending then name.
  final List<AdminDashboardDepartmentRow> departmentRows;

  /// Today's staff counts, sorted by count descending then full name.
  final List<AdminDashboardStaffRow> staffRows;

  /// Upcoming pending requests sorted by appointment date and start time.
  final List<Appointment> pendingAppointments;

  @override
  List<Object?> get props => [
    selectedBranchId,
    todayAppointmentCount,
    distinctBranchCount,
    distinctStaffCount,
    pendingCount,
    oldestPendingCreatedAt,
    completedCount,
    noShowCount,
    statusCounts,
    departmentRows,
    staffRows,
    pendingAppointments,
  ];
}
