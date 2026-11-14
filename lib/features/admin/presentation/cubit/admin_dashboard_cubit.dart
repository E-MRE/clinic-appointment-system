import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/core/usecases/no_params.dart';
import 'package:clinic_appointment_system/features/admin/presentation/cubit/admin_dashboard_state.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_dashboard_summary.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/models/admin_appointments_query.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_admin_appointments_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_pending_appointments_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/data_result_appointment_error_code.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Combines today's and pending appointment observations with the clinic
/// catalog to publish a branch-filtered administrator dashboard summary.
final class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  /// Injects both appointment observations and the clock used to define today.
  AdminDashboardCubit(
    this._watchAdminAppointments,
    this._watchPendingAppointments,
    this._clock,
  ) : super(const AdminDashboardLoading()) {
    _watch();
  }

  final WatchAdminAppointmentsUseCase _watchAdminAppointments;
  final WatchPendingAppointmentsUseCase _watchPendingAppointments;
  final Clock _clock;
  StreamSubscription<DataResult<List<Appointment>>>? _todaySubscription;
  StreamSubscription<DataResult<List<Appointment>>>? _pendingSubscription;
  List<Appointment>? _todayAppointments;
  List<Appointment>? _pendingAppointments;
  ClinicCatalog? _catalog;
  CalendarDate? _today;
  String? _selectedBranchId;
  int _watchGeneration = 0;
  bool _isClosing = false;

  bool get _isClosingOrClosed => _isClosing || isClosed;

  /// Replaces the directory snapshot used to resolve dashboard row labels.
  ///
  /// A page should listen to `ClinicCatalogCubit` and pass each loaded catalog
  /// here; the dashboard owns its independent appointment observations.
  void updateCatalog(ClinicCatalog catalog) {
    if (_isClosingOrClosed) return;
    _catalog = catalog;
    _emitSummaryIfReady();
  }

  /// Filters every summary figure to [branchId], or restores all branches
  /// when [branchId] is null.
  void selectBranch(String? branchId) {
    if (_isClosingOrClosed || _selectedBranchId == branchId) return;
    _selectedBranchId = branchId;
    _emitSummaryIfReady();
  }

  /// Restarts both appointment observations after a failure.
  void retry() {
    if (_isClosingOrClosed) return;
    _watch();
  }

  void _watch() {
    final generation = ++_watchGeneration;
    _cancelSubscriptions();
    _todayAppointments = null;
    _pendingAppointments = null;
    final now = _clock.now();
    final today = CalendarDate.fromDateTime(now);
    _today = today;
    emit(const AdminDashboardLoading());

    try {
      final todaySubscription = _watchAdminAppointments
          .call(AdminAppointmentsQuery(from: today, through: today))
          .listen(
            (DataResult<List<Appointment>> result) {
              _onTodayResult(result, generation);
            },
            onError: (Object _) {
              _fail(AppointmentErrorCode.unavailable, generation);
            },
          );
      if (!_isCurrent(generation)) {
        unawaited(todaySubscription.cancel());
        return;
      }
      _todaySubscription = todaySubscription;

      final pendingSubscription = _watchPendingAppointments
          .call(const NoParams())
          .listen(
            (DataResult<List<Appointment>> result) {
              _onPendingResult(result, generation);
            },
            onError: (Object _) {
              _fail(AppointmentErrorCode.unavailable, generation);
            },
          );
      if (!_isCurrent(generation)) {
        unawaited(pendingSubscription.cancel());
        return;
      }
      _pendingSubscription = pendingSubscription;
    } on Exception {
      _fail(AppointmentErrorCode.unavailable, generation);
    }
  }

  void _onTodayResult(DataResult<List<Appointment>> result, int generation) {
    if (!_isCurrent(generation)) return;
    final appointments = result.data;
    if (result.isNotSuccess || appointments == null) {
      _fail(result.appointmentErrorCode, generation);
      return;
    }
    _todayAppointments = appointments;
    _emitSummaryIfReady();
  }

  void _onPendingResult(DataResult<List<Appointment>> result, int generation) {
    if (!_isCurrent(generation)) return;
    final appointments = result.data;
    if (result.isNotSuccess || appointments == null) {
      _fail(result.appointmentErrorCode, generation);
      return;
    }
    _pendingAppointments = appointments;
    _emitSummaryIfReady();
  }

  void _emitSummaryIfReady() {
    if (_isClosingOrClosed) return;
    final todayAppointments = _todayAppointments;
    final pendingAppointments = _pendingAppointments;
    final today = _today;
    final catalog = _catalog;
    if (todayAppointments == null ||
        pendingAppointments == null ||
        today == null ||
        catalog == null) {
      return;
    }
    emit(
      AdminDashboardLoaded(
        AdminDashboardSummary.fromAppointments(
          todayAppointments: todayAppointments,
          pendingAppointments: pendingAppointments,
          today: today,
          catalog: catalog,
          selectedBranchId: _selectedBranchId,
        ),
      ),
    );
  }

  void _fail(AppointmentErrorCode errorCode, int generation) {
    if (!_isCurrent(generation)) return;
    _watchGeneration++;
    _cancelSubscriptions();
    _todayAppointments = null;
    _pendingAppointments = null;
    emit(AdminDashboardFailure(errorCode));
  }

  bool _isCurrent(int generation) {
    return !_isClosingOrClosed && generation == _watchGeneration;
  }

  void _cancelSubscriptions() {
    unawaited(_todaySubscription?.cancel());
    unawaited(_pendingSubscription?.cancel());
    _todaySubscription = null;
    _pendingSubscription = null;
  }

  /// Cancels both observations before closing.
  @override
  Future<void> close() async {
    _isClosing = true;
    _watchGeneration++;
    _cancelSubscriptions();
    await super.close();
  }
}
