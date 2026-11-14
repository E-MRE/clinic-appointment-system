import 'package:clinic_appointment_system/core/collections/count_ranking.dart';
import 'package:clinic_appointment_system/core/extensions/iterable_count_by.dart';
import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_status_filter.dart';
import 'package:clinic_appointment_system/features/admin/presentation/extensions/appointment_status_admin_filter.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_dashboard_department_row.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_dashboard_scope.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_dashboard_staff_row.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_dashboard_status_count.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_dashboard_summary.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/services/appointment_start_comparator.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/appointment_oldest_request.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// Calculates immutable dashboard figures from appointments and a catalog.
final class AdminDashboardCalculator {
  /// Injects the shared ranking and appointment ordering policies.
  const AdminDashboardCalculator(this._countRanking, this._startComparator);

  final CountRanking _countRanking;
  final AppointmentStartComparator _startComparator;

  int get _zeroCount => 0;

  List<AdminStatusFilter> get _statusDisplayOrder => const [
    AdminStatusFilter.completed,
    AdminStatusFilter.approved,
    AdminStatusFilter.pending,
    AdminStatusFilter.noShow,
    AdminStatusFilter.cancelled,
    AdminStatusFilter.rejected,
  ];

  /// Calculates the dashboard summary from the observed appointments and scope.
  AdminDashboardSummary calculate({
    required List<Appointment> todayAppointments,
    required List<Appointment> pendingAppointments,
    required AdminDashboardScope scope,
    required ClinicCatalog catalog,
  }) {
    final scopedTodayAppointments = todayAppointments
        .where(scope.includesToday)
        .toList();
    final upcomingPendingAppointments =
        pendingAppointments.where(scope.includesUpcomingPending).toList()
          ..sort(_startComparator.call);
    final statusCounts = scopedTodayAppointments.countBy(
      (Appointment appointment) => appointment.status.adminFilter,
    );
    final statusRows = List<AdminDashboardStatusCount>.unmodifiable(
      _statusRows(statusCounts),
    );

    return AdminDashboardSummary(
      selectedBranchId: scope.branchId,
      todayAppointmentCount: scopedTodayAppointments.length,
      distinctBranchCount: scopedTodayAppointments
          .map((Appointment appointment) => appointment.branchId)
          .toSet()
          .length,
      distinctStaffCount: scopedTodayAppointments
          .map((Appointment appointment) => appointment.staffId)
          .toSet()
          .length,
      pendingCount: upcomingPendingAppointments.length,
      oldestPendingCreatedAt: upcomingPendingAppointments.oldestRequestedAt,
      completedCount: statusCounts[AdminStatusFilter.completed] ?? _zeroCount,
      noShowCount: statusCounts[AdminStatusFilter.noShow] ?? _zeroCount,
      statusCounts: statusRows,
      departmentRows: _departmentRows(scopedTodayAppointments, catalog),
      staffRows: _staffRows(scopedTodayAppointments, catalog),
      pendingAppointments: List<Appointment>.unmodifiable(
        upcomingPendingAppointments,
      ),
    );
  }

  List<AdminDashboardStatusCount> _statusRows(
    Map<AdminStatusFilter, int> counts,
  ) {
    final rows = <AdminDashboardStatusCount>[];
    for (final status in _statusDisplayOrder) {
      final count = counts[status];
      if (count == null) continue;
      rows.add(AdminDashboardStatusCount(status: status, count: count));
    }
    return rows;
  }

  List<AdminDashboardDepartmentRow> _departmentRows(
    List<Appointment> appointments,
    ClinicCatalog catalog,
  ) {
    final rankedCounts = _countRanking.rank(
      appointments.countBy(
        (Appointment appointment) => appointment.departmentId,
      ),
      (String departmentId) =>
          catalog.departmentById(departmentId)?.name ?? departmentId,
    );
    return List<AdminDashboardDepartmentRow>.unmodifiable([
      for (final ranked in rankedCounts)
        AdminDashboardDepartmentRow(
          name: ranked.label,
          count: ranked.count,
          fractionOfMaximum: ranked.fractionOfMaximum,
        ),
    ]);
  }

  List<AdminDashboardStaffRow> _staffRows(
    List<Appointment> appointments,
    ClinicCatalog catalog,
  ) {
    final rankedCounts = _countRanking.rank(
      appointments.countBy((Appointment appointment) => appointment.staffId),
      (String staffId) => catalog.staffById(staffId)?.fullName ?? staffId,
    );
    final rows = <AdminDashboardStaffRow>[];
    for (final ranked in rankedCounts) {
      final staff = catalog.staffById(ranked.key);
      rows.add(
        AdminDashboardStaffRow(
          fullName: ranked.label,
          caption: _staffCaption(staff, catalog),
          count: ranked.count,
          fractionOfMaximum: ranked.fractionOfMaximum,
        ),
      );
    }
    return List<AdminDashboardStaffRow>.unmodifiable(rows);
  }

  String _staffCaption(Staff? staff, ClinicCatalog catalog) {
    if (staff == null) return '';
    final department = catalog.departmentById(staff.departmentId)?.name;
    final branch = catalog.branchById(staff.branchId)?.name;
    return '${department ?? staff.departmentId} · ${branch ?? staff.branchId}';
  }
}
