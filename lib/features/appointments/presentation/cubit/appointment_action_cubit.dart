import 'package:clinic_appointment_system/features/appointments/domain/actors/appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/models/appointment_status_request.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/change_appointment_status_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/cubit/appointment_action_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Applies one kind of lifecycle action to appointments, one request at a
/// time. The use case applies the domain's transition rules to the stored
/// appointment; results arriving after [close] are ignored.
/// Subclasses only choose the [action] they perform.
abstract class AppointmentActionCubit extends Cubit<AppointmentActionState> {
  /// Injects the lifecycle use case.
  AppointmentActionCubit(this._changeStatus)
    : super(const AppointmentActionIdle());

  final ChangeAppointmentStatusUseCase _changeStatus;
  bool _isRequestInFlight = false;
  bool _isClosing = false;

  /// Subclasses must return the lifecycle action this cubit requests.
  AppointmentAction get action;

  bool get _isClosingOrClosed => _isClosing || isClosed;

  /// Requests [action] on [appointment] as [by], with an optional [reason];
  /// ignored while another request runs or the cubit is closing.
  Future<void> perform(
    Appointment appointment, {
    required AppointmentActor by,
    String? reason,
  }) async {
    if (_isClosingOrClosed || _isRequestInFlight) return;
    _isRequestInFlight = true;
    emit(AppointmentActionInProgress(appointment.id));
    try {
      final result = await _changeStatus(
        AppointmentStatusRequest(
          appointmentId: appointment.id,
          action: action,
          by: by,
          reason: reason,
        ),
      );
      if (result.isSuccess) {
        _emit(const AppointmentActionSuccess());
        return;
      }
      _emit(
        AppointmentActionFailure(
          result.errorCode ?? AppointmentErrorCode.unavailable,
        ),
      );
    } on Exception {
      _emit(const AppointmentActionFailure(AppointmentErrorCode.unavailable));
    } finally {
      _isRequestInFlight = false;
    }
  }

  void _emit(AppointmentActionState state) {
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
