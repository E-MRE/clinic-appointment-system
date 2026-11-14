import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/features/admin/presentation/cubit/admin_appointments_state.dart';
import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_status_filter.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_appointment_filter.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/models/admin_appointments_query.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_admin_appointments_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/data_result_appointment_error_code.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Watches a date range and derives the administrator's filtered, paged list.
final class AdminAppointmentsCubit extends Cubit<AdminAppointmentsState> {
  /// Creates the current-week filter and starts observing its appointments.
  factory AdminAppointmentsCubit(
    WatchAdminAppointmentsUseCase watchAppointments,
    Clock clock,
  ) {
    final filter = AdminAppointmentFilter.currentWeek(clock: clock);
    return AdminAppointmentsCubit._(watchAppointments, filter);
  }

  AdminAppointmentsCubit._(
    this._watchAppointments,
    AdminAppointmentFilter filter,
  ) : _filter = filter,
      super(AdminAppointmentsLoading(filter)) {
    watch();
  }

  final WatchAdminAppointmentsUseCase _watchAppointments;
  StreamSubscription<DataResult<List<Appointment>>>? _subscription;
  AdminAppointmentFilter _filter;
  int _currentPage = 1;
  int _generation = 0;
  bool _isClosing = false;

  bool get _isClosingOrClosed => _isClosing || isClosed;
  int get _firstPage => 1;
  int get _pageStep => 1;

  /// Replaces the filter and watches again only when its date range changes.
  void updateFilter(AdminAppointmentFilter filter) {
    if (filter == _filter || _isClosingOrClosed) return;
    final rangeChanged =
        filter.from != _filter.from || filter.through != _filter.through;
    _filter = filter;
    _currentPage = _firstPage;
    if (rangeChanged) {
      watch();
      return;
    }
    _refreshForCurrentFilter();
  }

  /// Selects a branch and clears dependent selections outside it.
  void selectBranch(String? branchId, ClinicCatalog catalog) {
    updateFilter(_filter.withBranch(branchId, catalog));
  }

  /// Selects a department and clears a staff member outside it.
  void selectDepartment(String? departmentId, ClinicCatalog catalog) {
    updateFilter(_filter.withDepartment(departmentId, catalog));
  }

  /// Selects a staff member.
  void selectStaff(String? staffId) {
    updateFilter(_filter.withStaff(staffId));
  }

  /// Replaces the date range.
  void selectDateRange(CalendarDate from, CalendarDate through) {
    updateFilter(_filter.withDateRange(from, through));
  }

  /// Replaces the selected status groups.
  void selectStatuses(Set<AdminStatusFilter> statuses) {
    updateFilter(_filter.withStatuses(statuses));
  }

  /// Replaces the patient-name query.
  void searchPatient(String query) {
    updateFilter(_filter.withPatientQuery(query));
  }

  /// Clears every criterion except the date range.
  void clearFilters() {
    updateFilter(_filter.cleared());
  }

  /// Shows [page], clamped to the currently available pages.
  void goToPage(int page) {
    final currentState = state;
    if (currentState is! AdminAppointmentsLoaded) return;
    final lastPage = currentState.pageCount < _firstPage
        ? _firstPage
        : currentState.pageCount;
    final nextPage = page.clamp(_firstPage, lastPage).toInt();
    if (nextPage == _currentPage) return;
    _currentPage = nextPage;
    _emitLoaded(currentState.allAppointmentsInRange);
  }

  /// Advances to the next page when one exists.
  void nextPage() {
    final currentState = state;
    if (currentState is AdminAppointmentsLoaded) {
      goToPage(currentState.currentPage + _pageStep);
    }
  }

  /// Returns to the previous page when one exists.
  void previousPage() {
    final currentState = state;
    if (currentState is AdminAppointmentsLoaded) {
      goToPage(currentState.currentPage - _pageStep);
    }
  }

  /// Restarts the observation for the latest filter.
  void retry() {
    watch();
  }

  /// Replaces the current date-range observation.
  void watch() {
    if (_isClosingOrClosed) return;
    _cancel();
    final generation = ++_generation;
    emit(AdminAppointmentsLoading(_filter));
    try {
      _subscription = _watchAppointments
          .call(
            AdminAppointmentsQuery(
              from: _filter.from,
              through: _filter.through,
            ),
          )
          .listen(
            (DataResult<List<Appointment>> result) {
              _onResult(result, generation);
            },
            onError: (Object _) {
              _emitFailure(AppointmentErrorCode.unavailable, generation);
            },
          );
    } on Exception {
      _emitFailure(AppointmentErrorCode.unavailable, generation);
    }
  }

  void _onResult(DataResult<List<Appointment>> result, int generation) {
    if (generation != _generation || _isClosingOrClosed) return;
    final appointments = result.data;
    if (result.isNotSuccess || appointments == null) {
      _emitFailure(result.appointmentErrorCode, generation);
      return;
    }
    _emitLoaded(appointments);
  }

  void _emitFailure(AppointmentErrorCode errorCode, int generation) {
    if (generation != _generation || _isClosingOrClosed) return;
    emit(AdminAppointmentsFailure(filter: _filter, errorCode: errorCode));
  }

  void _refreshForCurrentFilter() {
    final currentState = state;
    if (currentState is AdminAppointmentsLoaded) {
      _emitLoaded(currentState.allAppointmentsInRange);
      return;
    }
    if (currentState is AdminAppointmentsFailure) {
      emit(
        AdminAppointmentsFailure(
          filter: _filter,
          errorCode: currentState.errorCode,
        ),
      );
      return;
    }
    emit(AdminAppointmentsLoading(_filter));
  }

  void _emitLoaded(List<Appointment> appointments) {
    if (_isClosingOrClosed) return;
    final loaded = AdminAppointmentsLoaded(
      filter: _filter,
      allAppointmentsInRange: appointments,
      currentPage: _currentPage,
    );
    _currentPage = loaded.currentPage;
    emit(loaded);
  }

  void _cancel() {
    unawaited(_subscription?.cancel());
    _subscription = null;
  }

  /// Cancels the date-range observation before closing.
  @override
  Future<void> close() async {
    _isClosing = true;
    _generation++;
    _cancel();
    await super.close();
  }
}
