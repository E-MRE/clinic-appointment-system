import 'package:clinic_appointment_system/features/appointments/domain/actors/patient_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/models/appointment_status_request.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/change_appointment_status_use_case.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/patient_appointment_cancel_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cancels an appointment as its patient, one request at a time.
/// The use case applies the domain's cancellation rules to the stored
/// appointment; results arriving after [close] are ignored.
final class PatientAppointmentCancelCubit
    extends Cubit<PatientAppointmentCancelState> {
  /// Injects the lifecycle use case.
  PatientAppointmentCancelCubit(this._changeStatus)
    : super(const PatientAppointmentCancelIdle());

  final ChangeAppointmentStatusUseCase _changeStatus;
  bool _isRequestInFlight = false;
  bool _isClosing = false;

  bool get _isClosingOrClosed => _isClosing || isClosed;

  /// Requests cancellation of [appointment] by [patient]; ignored while
  /// another request runs or the cubit is closing.
  Future<void> cancel(
    Appointment appointment, {
    required PatientAppointmentActor patient,
  }) async {
    if (_isClosingOrClosed || _isRequestInFlight) return;
    _isRequestInFlight = true;
    emit(const PatientAppointmentCancelInProgress());
    try {
      final result = await _changeStatus(
        AppointmentStatusRequest(
          appointmentId: appointment.id,
          action: AppointmentAction.cancelByPatient,
          by: patient,
        ),
      );
      if (result.isSuccess) {
        _emit(const PatientAppointmentCancelSuccess());
        return;
      }
      _emit(
        PatientAppointmentCancelFailure(
          result.errorCode ?? AppointmentErrorCode.unavailable,
        ),
      );
    } on Exception {
      _emit(
        const PatientAppointmentCancelFailure(AppointmentErrorCode.unavailable),
      );
    } finally {
      _isRequestInFlight = false;
    }
  }

  void _emit(PatientAppointmentCancelState state) {
    if (_isClosingOrClosed) return;
    emit(state);
  }

  /// Closes the cubit and ignores any pending request completion.
  @override
  Future<void> close() async {
    _isClosing = true;
    await super.close();
  }
}
