import 'dart:async';

import 'package:clinic_appointment_system/core/constants/staff_request_constants.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/models/staff_appointments_query.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_staff_appointments_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/data_result_appointment_error_code.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_appointments_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Observes all appointments assigned to one staff member from
/// today − [StaffRequestConstants.historyLookbackDays] through
/// today + [StaffRequestConstants.lookaheadDays].
/// Failed results keep their [AppointmentErrorCode]; stream errors report
/// [AppointmentErrorCode.unavailable].
final class StaffAppointmentsCubit extends Cubit<StaffAppointmentsState> {
  /// Injects the staff observation use case and the clock fixing "today".
  StaffAppointmentsCubit(this._watchAppointments, this._clock)
    : super(const StaffAppointmentsLoading());

  final WatchStaffAppointmentsUseCase _watchAppointments;
  final Clock _clock;
  StreamSubscription<DataResult<List<Appointment>>>? _subscription;
  String? _staffId;
  bool _isClosing = false;

  bool get _isClosingOrClosed => _isClosing || isClosed;

  /// Starts observing the appointments of [staffId], replacing any earlier
  /// observation.
  void watch(String staffId) {
    if (_isClosingOrClosed) return;
    _staffId = staffId;
    _cancel();
    emit(const StaffAppointmentsLoading());
    try {
      _subscription = _watchAppointments
          .call(_queryFor(staffId))
          .listen(
            _onResult,
            onError: (Object _) {
              _emit(
                const StaffAppointmentsFailure(
                  AppointmentErrorCode.unavailable,
                ),
              );
            },
          );
    } on Exception {
      _emit(const StaffAppointmentsFailure(AppointmentErrorCode.unavailable));
    }
  }

  /// Restarts the last observation; does nothing before the first [watch].
  void retry() {
    final staffId = _staffId;
    if (staffId != null) watch(staffId);
  }

  StaffAppointmentsQuery _queryFor(String staffId) {
    final now = _clock.now();
    final from = CalendarDate.fromDateTime(
      DateTime(
        now.year,
        now.month,
        now.day - StaffRequestConstants.historyLookbackDays,
      ),
    );
    final through = CalendarDate.fromDateTime(
      DateTime(
        now.year,
        now.month,
        now.day + StaffRequestConstants.lookaheadDays,
      ),
    );
    return StaffAppointmentsQuery(
      staffId: staffId,
      from: from,
      through: through,
    );
  }

  void _onResult(DataResult<List<Appointment>> result) {
    final appointments = result.data;
    if (result.isNotSuccess || appointments == null) {
      _emit(StaffAppointmentsFailure(result.appointmentErrorCode));
      return;
    }
    _emit(
      StaffAppointmentsLoaded(
        appointments: appointments,
        pendingRequests: _pendingRequests(appointments),
      ),
    );
  }

  /// Pending appointments starting now or later, earliest first.
  List<Appointment> _pendingRequests(List<Appointment> appointments) {
    final now = _clock.now();
    return [
      for (final appointment in appointments)
        if (appointment.status == AppointmentStatus.pending &&
            !appointment.startsAt.isBefore(now))
          appointment,
    ]..sort((a, b) => a.startsAt.compareTo(b.startsAt));
  }

  void _emit(StaffAppointmentsState state) {
    if (_isClosingOrClosed) return;
    emit(state);
  }

  void _cancel() {
    unawaited(_subscription?.cancel());
    _subscription = null;
  }

  /// Cancels the observation before closing.
  @override
  Future<void> close() async {
    _isClosing = true;
    _cancel();
    await super.close();
  }
}
