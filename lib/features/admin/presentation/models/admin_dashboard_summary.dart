import 'package:clinic_appointment_system/core/extensions/turkish_alphabetical_comparison.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_status_filter.dart';
import 'package:clinic_appointment_system/features/admin/presentation/extensions/appointment_status_admin_filter.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_dashboard_department_row.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_dashboard_staff_row.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_dashboard_status_count.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:equatable/equatable.dart';

/// An immutable, branch-filtered snapshot of the administrator dashboard.
final class AdminDashboardSummary extends Equatable {
  /// Builds dashboard figures from today's appointments, pending requests and
  /// the directory snapshot used to resolve department, staff and branch names.
  factory AdminDashboardSummary.fromAppointments({
    required List<Appointment> todayAppointments,
    required List<Appointment> pendingAppointments,
    required CalendarDate today,
    required ClinicCatalog catalog,
    String? selectedBranchId,
  }) {
    final todaysAppointments = [
      for (final appointment in todayAppointments)
        if (appointment.date == today &&
            _matchesBranch(appointment, selectedBranchId))
          appointment,
    ];
    final upcomingPending = [
      for (final appointment in pendingAppointments)
        if (appointment.status == AppointmentStatus.pending &&
            !appointment.date.isBefore(today) &&
            _matchesBranch(appointment, selectedBranchId))
          appointment,
    ]..sort(_compareAppointmentStart);

    DateTime? oldestPendingCreatedAt;
    for (final appointment in upcomingPending) {
      final createdAt = appointment.history.first.at;
      if (oldestPendingCreatedAt == null ||
          createdAt.isBefore(oldestPendingCreatedAt)) {
        oldestPendingCreatedAt = createdAt;
      }
    }

    final statusCounts = _statusCounts(todaysAppointments);
    final departmentRows = _departmentRows(todaysAppointments, catalog);
    final staffRows = _staffRows(todaysAppointments, catalog);

    return AdminDashboardSummary._(
      selectedBranchId: selectedBranchId,
      todayAppointmentCount: todaysAppointments.length,
      distinctBranchCount: todaysAppointments
          .map((Appointment appointment) => appointment.branchId)
          .toSet()
          .length,
      distinctStaffCount: todaysAppointments
          .map((Appointment appointment) => appointment.staffId)
          .toSet()
          .length,
      pendingCount: upcomingPending.length,
      oldestPendingCreatedAt: oldestPendingCreatedAt,
      completedCount: _countStatus(
        todaysAppointments,
        AppointmentStatus.completed,
      ),
      noShowCount: _countStatus(todaysAppointments, AppointmentStatus.noShow),
      statusCounts: statusCounts,
      departmentRows: departmentRows,
      staffRows: staffRows,
      pendingAppointments: upcomingPending,
    );
  }

  AdminDashboardSummary._({
    required this.selectedBranchId,
    required this.todayAppointmentCount,
    required this.distinctBranchCount,
    required this.distinctStaffCount,
    required this.pendingCount,
    required this.oldestPendingCreatedAt,
    required this.completedCount,
    required this.noShowCount,
    required List<AdminDashboardStatusCount> statusCounts,
    required List<AdminDashboardDepartmentRow> departmentRows,
    required List<AdminDashboardStaffRow> staffRows,
    required List<Appointment> pendingAppointments,
  }) : statusCounts = List<AdminDashboardStatusCount>.unmodifiable(
         statusCounts,
       ),
       departmentRows = List<AdminDashboardDepartmentRow>.unmodifiable(
         departmentRows,
       ),
       staffRows = List<AdminDashboardStaffRow>.unmodifiable(staffRows),
       pendingAppointments = List<Appointment>.unmodifiable(
         pendingAppointments,
       );

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

  static bool _matchesBranch(Appointment appointment, String? branchId) {
    return branchId == null || appointment.branchId == branchId;
  }

  static int _compareAppointmentStart(Appointment first, Appointment second) {
    final dateOrder = first.date.compareTo(second.date);
    if (dateOrder != 0) return dateOrder;
    final timeOrder = first.range.start.compareTo(second.range.start);
    if (timeOrder != 0) return timeOrder;
    return first.id.compareTo(second.id);
  }

  static List<AdminDashboardStatusCount> _statusCounts(
    List<Appointment> appointments,
  ) {
    const displayOrder = [
      AdminStatusFilter.completed,
      AdminStatusFilter.approved,
      AdminStatusFilter.pending,
      AdminStatusFilter.noShow,
      AdminStatusFilter.cancelled,
      AdminStatusFilter.rejected,
    ];
    final counts = <AdminStatusFilter, int>{};
    for (final appointment in appointments) {
      final filter = appointment.status.adminFilter;
      counts.update(filter, (int count) => count + 1, ifAbsent: () => 1);
    }
    return [
      for (final filter in displayOrder)
        if (counts.containsKey(filter))
          AdminDashboardStatusCount(status: filter, count: counts[filter] ?? 0),
    ];
  }

  static int _countStatus(
    List<Appointment> appointments,
    AppointmentStatus status,
  ) {
    return appointments
        .where((Appointment appointment) => appointment.status == status)
        .length;
  }

  static List<AdminDashboardDepartmentRow> _departmentRows(
    List<Appointment> appointments,
    ClinicCatalog catalog,
  ) {
    final counts = _countBy(
      appointments,
      (Appointment appointment) => appointment.departmentId,
    );
    final rows =
        [
          for (final entry in counts.entries)
            (
              id: entry.key,
              name: catalog.departmentById(entry.key)?.name ?? entry.key,
              count: entry.value,
            ),
        ]..sort((first, second) {
          final countOrder = second.count.compareTo(first.count);
          if (countOrder != 0) return countOrder;
          final nameOrder = first.name.compareTurkishAlphabetically(
            second.name,
          );
          if (nameOrder != 0) return nameOrder;
          return first.id.compareTo(second.id);
        });
    final maximum = _maximumCount(rows.map((row) => row.count));
    return [
      for (final row in rows)
        AdminDashboardDepartmentRow(
          name: row.name,
          count: row.count,
          fractionOfMaximum: row.count / maximum,
        ),
    ];
  }

  static List<AdminDashboardStaffRow> _staffRows(
    List<Appointment> appointments,
    ClinicCatalog catalog,
  ) {
    final counts = _countBy(
      appointments,
      (Appointment appointment) => appointment.staffId,
    );
    final rows =
        [
          for (final entry in counts.entries)
            (
              id: entry.key,
              fullName: catalog.staffById(entry.key)?.fullName ?? entry.key,
              caption: _staffCaption(catalog.staffById(entry.key), catalog),
              count: entry.value,
            ),
        ]..sort((first, second) {
          final countOrder = second.count.compareTo(first.count);
          if (countOrder != 0) return countOrder;
          final nameOrder = first.fullName.compareTurkishAlphabetically(
            second.fullName,
          );
          if (nameOrder != 0) return nameOrder;
          return first.id.compareTo(second.id);
        });
    final maximum = _maximumCount(rows.map((row) => row.count));
    return [
      for (final row in rows)
        AdminDashboardStaffRow(
          fullName: row.fullName,
          caption: row.caption,
          count: row.count,
          fractionOfMaximum: row.count / maximum,
        ),
    ];
  }

  static String _staffCaption(Staff? staff, ClinicCatalog catalog) {
    if (staff == null) return '';
    final department = catalog.departmentById(staff.departmentId)?.name;
    final branch = catalog.branchById(staff.branchId)?.name;
    return '${department ?? staff.departmentId} · ${branch ?? staff.branchId}';
  }

  static Map<String, int> _countBy(
    List<Appointment> appointments,
    String Function(Appointment appointment) keyOf,
  ) {
    final counts = <String, int>{};
    for (final appointment in appointments) {
      counts.update(
        keyOf(appointment),
        (int count) => count + 1,
        ifAbsent: () => 1,
      );
    }
    return counts;
  }

  static int _maximumCount(Iterable<int> counts) {
    int maximum = 0;
    for (final count in counts) {
      if (count > maximum) maximum = count;
    }
    return maximum;
  }
}
