import 'package:clinic_appointment_system/core/extensions/turkish_case_folding.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/core/time/clock_today.dart';
import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_status_filter.dart';
import 'package:clinic_appointment_system/features/admin/presentation/extensions/appointment_status_admin_filter.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:equatable/equatable.dart';

/// Immutable criteria for the administrator's appointment list.
final class AdminAppointmentFilter extends Equatable {
  /// Creates a filter with an inclusive date range and no other restrictions.
  AdminAppointmentFilter({
    required this.from,
    required this.through,
    this.branchId,
    this.departmentId,
    this.staffId,
    Set<AdminStatusFilter> statuses = const {},
    String patientQuery = '',
  }) : statuses = Set<AdminStatusFilter>.unmodifiable(statuses),
       patientQuery = patientQuery.trim();

  /// Starts on Monday and ends on Sunday of the week containing [clock.today].
  factory AdminAppointmentFilter.currentWeek({required Clock clock}) {
    final today = clock.today;
    final from = CalendarDate.fromDateTime(
      DateTime(today.year, today.month, today.day - today.weekday.index),
    );
    return AdminAppointmentFilter(
      from: from,
      through: CalendarDate.fromDateTime(
        DateTime(from.year, from.month, from.day + _daysPerWeek - 1),
      ),
    );
  }

  static const Object _unchanged = Object();
  static const int _daysPerWeek = 7;

  /// The first included calendar date.
  final CalendarDate from;

  /// The last included calendar date.
  final CalendarDate through;

  /// The selected branch, or null for every branch.
  final String? branchId;

  /// The selected department, or null for every department.
  final String? departmentId;

  /// The selected staff member, or null for every staff member.
  final String? staffId;

  /// Selected status groups; an empty set includes every status.
  final Set<AdminStatusFilter> statuses;

  /// Trimmed patient-name search text.
  final String patientQuery;

  /// Copies this filter while retaining values whose arguments are omitted.
  /// Use [withBranch] and [withDepartment] for catalog-aware selections.
  AdminAppointmentFilter copyWith({
    CalendarDate? from,
    CalendarDate? through,
    Object? branchId = _unchanged,
    Object? departmentId = _unchanged,
    Object? staffId = _unchanged,
    Set<AdminStatusFilter>? statuses,
    String? patientQuery,
  }) {
    return AdminAppointmentFilter(
      from: from ?? this.from,
      through: through ?? this.through,
      branchId: identical(branchId, _unchanged)
          ? this.branchId
          : branchId as String?,
      departmentId: identical(departmentId, _unchanged)
          ? this.departmentId
          : departmentId as String?,
      staffId: identical(staffId, _unchanged)
          ? this.staffId
          : staffId as String?,
      statuses: statuses ?? this.statuses,
      patientQuery: patientQuery ?? this.patientQuery,
    );
  }

  /// Copies this filter with a new inclusive date range.
  AdminAppointmentFilter withDateRange(
    CalendarDate from,
    CalendarDate through,
  ) {
    return copyWith(from: from, through: through);
  }

  /// Chooses [branchId], clearing dependent selections outside that branch.
  AdminAppointmentFilter withBranch(String? branchId, ClinicCatalog catalog) {
    String? nextDepartmentId = departmentId;
    final department = nextDepartmentId == null
        ? null
        : catalog.departmentById(nextDepartmentId);
    if (branchId != null && department?.branchId != branchId) {
      nextDepartmentId = null;
    }

    String? nextStaffId = staffId;
    final staff = nextStaffId == null ? null : catalog.staffById(nextStaffId);
    if (branchId != null && staff?.branchId != branchId) {
      nextStaffId = null;
    } else if (nextDepartmentId != null &&
        staff?.departmentId != nextDepartmentId) {
      nextStaffId = null;
    }

    return copyWith(
      branchId: branchId,
      departmentId: nextDepartmentId,
      staffId: nextStaffId,
    );
  }

  /// Chooses [departmentId], clearing a selected staff member outside it.
  AdminAppointmentFilter withDepartment(
    String? departmentId,
    ClinicCatalog catalog,
  ) {
    String? nextStaffId = staffId;
    final staff = nextStaffId == null ? null : catalog.staffById(nextStaffId);
    if (departmentId != null && staff?.departmentId != departmentId) {
      nextStaffId = null;
    }

    return copyWith(departmentId: departmentId, staffId: nextStaffId);
  }

  /// Chooses [staffId] without changing the other criteria.
  AdminAppointmentFilter withStaff(String? staffId) {
    return copyWith(staffId: staffId);
  }

  /// Replaces selected status groups; an empty set means all statuses.
  AdminAppointmentFilter withStatuses(Set<AdminStatusFilter> statuses) {
    return copyWith(statuses: statuses);
  }

  /// Replaces the patient search text, trimming its outer whitespace.
  AdminAppointmentFilter withPatientQuery(String patientQuery) {
    return copyWith(patientQuery: patientQuery);
  }

  /// Removes all non-date criteria.
  AdminAppointmentFilter cleared() {
    return AdminAppointmentFilter(from: from, through: through);
  }

  /// Whether [appointment] meets every selected criterion.
  bool matches(Appointment appointment) {
    if (appointment.date.isBefore(from) || appointment.date.isAfter(through)) {
      return false;
    }
    if (branchId != null && appointment.branchId != branchId) return false;
    if (departmentId != null && appointment.departmentId != departmentId) {
      return false;
    }
    if (staffId != null && appointment.staffId != staffId) return false;
    if (statuses.isNotEmpty &&
        !statuses.contains(appointment.status.adminFilter)) {
      return false;
    }

    return appointment.patientName.containsTurkishInsensitive(patientQuery);
  }

  /// All available branch choices from [catalog].
  List<Branch> branchesIn(ClinicCatalog catalog) {
    return List<Branch>.unmodifiable(catalog.branches);
  }

  /// Departments narrowed to the selected branch, when one is selected.
  List<Department> departmentsIn(ClinicCatalog catalog) {
    return List<Department>.unmodifiable(
      catalog.departments.where(
        (Department department) =>
            branchId == null || department.branchId == branchId,
      ),
    );
  }

  /// Staff narrowed to the selected branch and department, when selected.
  List<Staff> staffIn(ClinicCatalog catalog) {
    return List<Staff>.unmodifiable(
      catalog.staff.where(
        (Staff member) =>
            (branchId == null || member.branchId == branchId) &&
            (departmentId == null || member.departmentId == departmentId),
      ),
    );
  }

  @override
  List<Object?> get props => [
    from,
    through,
    branchId,
    departmentId,
    staffId,
    statuses,
    patientQuery,
  ];
}
