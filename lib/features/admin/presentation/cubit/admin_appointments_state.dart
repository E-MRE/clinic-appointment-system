import 'package:clinic_appointment_system/core/constants/admin_appointment_constants.dart';
import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_status_filter.dart';
import 'package:clinic_appointment_system/features/admin/presentation/extensions/appointment_status_admin_filter.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_appointment_filter.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';

/// The closed set of states emitted for the administrator's appointment list.
sealed class AdminAppointmentsState {
  /// Creates a state holding the active filter.
  const AdminAppointmentsState(this.filter);

  /// Current criteria, retained while loading or after a failure.
  final AdminAppointmentFilter filter;
}

/// Waiting for the appointment observation to emit.
final class AdminAppointmentsLoading extends AdminAppointmentsState {
  /// Creates the loading state for [filter].
  const AdminAppointmentsLoading(super.filter);
}

/// The appointment observation failed with [errorCode].
final class AdminAppointmentsFailure extends AdminAppointmentsState {
  /// Creates the failure state for [filter].
  const AdminAppointmentsFailure({
    required AdminAppointmentFilter filter,
    required this.errorCode,
  }) : super(filter);

  /// Provider-independent reason for the failed observation.
  final AppointmentErrorCode errorCode;
}

/// The observed appointments and all list data derived from the active filter.
final class AdminAppointmentsLoaded extends AdminAppointmentsState {
  int get _firstPage => 1;
  int get _noItems => 0;

  /// Filters, sorts and pages [allAppointmentsInRange].
  factory AdminAppointmentsLoaded({
    required AdminAppointmentFilter filter,
    required List<Appointment> allAppointmentsInRange,
    required int currentPage,
  }) {
    const int firstPage = 1;
    const int noItems = 0;
    final allAppointments = List<Appointment>.unmodifiable(
      allAppointmentsInRange,
    );
    final filteredAppointments = allAppointments.where(filter.matches).toList();
    filteredAppointments.sort(_compareAppointments);
    final pageCount =
        (filteredAppointments.length / AdminAppointmentConstants.rowsPerPage)
            .ceil();
    final boundedPage = currentPage
        .clamp(firstPage, pageCount < firstPage ? firstPage : pageCount)
        .toInt();
    final counts = <AdminStatusFilter, int>{
      for (final status in AdminStatusFilter.values) status: noItems,
    };
    for (final appointment in filteredAppointments) {
      final status = appointment.status.adminFilter;
      counts[status] = (counts[status] ?? noItems) + firstPage;
    }
    return AdminAppointmentsLoaded._(
      filter: filter,
      allAppointmentsInRange: allAppointments,
      filteredAppointments: List<Appointment>.unmodifiable(
        filteredAppointments,
      ),
      currentPage: boundedPage,
      statusCounts: Map<AdminStatusFilter, int>.unmodifiable(counts),
    );
  }

  const AdminAppointmentsLoaded._({
    required AdminAppointmentFilter filter,
    required this.allAppointmentsInRange,
    required this.filteredAppointments,
    required this.currentPage,
    required this.statusCounts,
  }) : super(filter);

  /// Every appointment from the watched date range, before client filtering.
  final List<Appointment> allAppointmentsInRange;

  /// Matching appointments sorted by date and start time ascending.
  final List<Appointment> filteredAppointments;

  /// The one-based current page number.
  final int currentPage;

  /// Number of pages, or zero when the filtered list is empty.
  int get pageCount =>
      (filteredAppointments.length / AdminAppointmentConstants.rowsPerPage)
          .ceil();

  /// The first zero-based index represented by [currentPage].
  int get _startIndex =>
      (currentPage - _firstPage) * AdminAppointmentConstants.rowsPerPage;

  /// Appointments shown on the current page.
  List<Appointment> get currentPageAppointments {
    final endIndex = (_startIndex + AdminAppointmentConstants.rowsPerPage)
        .clamp(_noItems, filteredAppointments.length)
        .toInt();
    return List<Appointment>.unmodifiable(
      filteredAppointments.sublist(_startIndex, endIndex),
    );
  }

  /// One-based first row number, or zero for an empty result.
  int get rangeStart =>
      filteredAppointments.isEmpty ? _noItems : _startIndex + _firstPage;

  /// One-based last row number, or zero for an empty result.
  int get rangeEnd {
    if (filteredAppointments.isEmpty) return _noItems;
    return _startIndex + currentPageAppointments.length;
  }

  /// Label with the first row, last row and total result count.
  String get rangeLabel =>
      '$rangeStart–$rangeEnd / ${filteredAppointments.length}';

  /// Counts for each admin status group, including zero-count groups.
  final Map<AdminStatusFilter, int> statusCounts;

  static int _compareAppointments(Appointment first, Appointment second) {
    const int equalOrder = 0;
    final dateOrder = first.date.compareTo(second.date);
    if (dateOrder != equalOrder) return dateOrder;
    return first.range.start.compareTo(second.range.start);
  }
}
