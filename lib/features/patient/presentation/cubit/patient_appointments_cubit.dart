import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_patient_appointments_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/data_result_appointment_error_code.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/patient_appointments_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Observes only the signed-in patient's appointments.
/// Failed results keep their [AppointmentErrorCode]; stream errors report
/// [AppointmentErrorCode.unavailable].
final class PatientAppointmentsCubit extends Cubit<PatientAppointmentsState> {
  /// Injects the owner-scoped observation use case.
  PatientAppointmentsCubit(this._watchAppointments)
    : super(const PatientAppointmentsLoading());

  final WatchPatientAppointmentsUseCase _watchAppointments;
  StreamSubscription<DataResult<List<Appointment>>>? _subscription;
  String? _patientId;
  bool _isClosing = false;

  bool get _isClosingOrClosed => _isClosing || isClosed;

  /// Starts observing the appointments of [patientId], replacing any
  /// earlier observation.
  void watch(String patientId) {
    if (_isClosingOrClosed) return;
    _patientId = patientId;
    _cancel();
    emit(const PatientAppointmentsLoading());
    try {
      _subscription = _watchAppointments
          .call(patientId)
          .listen(
            _onResult,
            onError: (Object _) {
              _emit(
                const PatientAppointmentsFailure(
                  AppointmentErrorCode.unavailable,
                ),
              );
            },
          );
    } on Exception {
      _emit(const PatientAppointmentsFailure(AppointmentErrorCode.unavailable));
    }
  }

  /// Restarts the last observation; does nothing before the first [watch].
  void retry() {
    final patientId = _patientId;
    if (patientId != null) watch(patientId);
  }

  void _onResult(DataResult<List<Appointment>> result) {
    final appointments = result.data;
    if (result.isNotSuccess || appointments == null) {
      _emit(PatientAppointmentsFailure(result.appointmentErrorCode));
      return;
    }
    _emit(PatientAppointmentsLoaded(appointments));
  }

  void _emit(PatientAppointmentsState state) {
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
    final subscription = _subscription;
    _subscription = null;
    await subscription?.cancel();
    await super.close();
  }
}
