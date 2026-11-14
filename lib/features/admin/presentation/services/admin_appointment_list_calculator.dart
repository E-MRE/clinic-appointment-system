import 'package:clinic_appointment_system/core/constants/admin_appointment_constants.dart';
import 'package:clinic_appointment_system/core/extensions/iterable_count_by.dart';
import 'package:clinic_appointment_system/features/admin/presentation/cubit/admin_appointments_state.dart';
import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_status_filter.dart';
import 'package:clinic_appointment_system/features/admin/presentation/extensions/appointment_status_admin_filter.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_appointment_filter.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/services/appointment_start_comparator.dart';

/// Filters, orders, pages and counts the administrator appointment list.
final class AdminAppointmentListCalculator {
  /// Injects the shared appointment ordering policy.
  const AdminAppointmentListCalculator(this._startComparator);

  final AppointmentStartComparator _startComparator;

  int get _firstPage => 1;
  int get _zeroCount => 0;

  /// Derives a loaded list state from the supplied appointments and criteria.
  AdminAppointmentsLoaded calculate({
    required AdminAppointmentFilter filter,
    required List<Appointment> allAppointmentsInRange,
    required int currentPage,
  }) {
    final allAppointments = List<Appointment>.unmodifiable(
      allAppointmentsInRange,
    );
    final filteredAppointments = allAppointments.where(filter.matches).toList()
      ..sort(_startComparator.call);
    final pageCount =
        (filteredAppointments.length / AdminAppointmentConstants.rowsPerPage)
            .ceil();
    final boundedPage = currentPage
        .clamp(_firstPage, _lastPage(pageCount))
        .toInt();
    final countsByStatus = filteredAppointments.countBy(
      (Appointment appointment) => appointment.status.adminFilter,
    );
    final statusCounts = <AdminStatusFilter, int>{};
    for (final status in AdminStatusFilter.values) {
      statusCounts[status] = countsByStatus[status] ?? _zeroCount;
    }

    return AdminAppointmentsLoaded(
      filter: filter,
      allAppointmentsInRange: allAppointments,
      filteredAppointments: List<Appointment>.unmodifiable(
        filteredAppointments,
      ),
      currentPage: boundedPage,
      statusCounts: Map<AdminStatusFilter, int>.unmodifiable(statusCounts),
    );
  }

  int _lastPage(int pageCount) {
    if (pageCount < _firstPage) return _firstPage;
    return pageCount;
  }
}
