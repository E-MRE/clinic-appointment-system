import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';

/// The closed set of states of a patient cancellation request.
sealed class PatientAppointmentCancelState {
  /// Creates a cancellation state.
  const PatientAppointmentCancelState();
}

/// No cancellation has been requested.
final class PatientAppointmentCancelIdle extends PatientAppointmentCancelState {
  /// Creates the idle state.
  const PatientAppointmentCancelIdle();
}

/// A cancellation request is running.
final class PatientAppointmentCancelInProgress
    extends PatientAppointmentCancelState {
  /// Creates the in-progress state.
  const PatientAppointmentCancelInProgress();
}

/// The appointment was cancelled.
final class PatientAppointmentCancelSuccess
    extends PatientAppointmentCancelState {
  /// Creates the success state.
  const PatientAppointmentCancelSuccess();
}

/// The cancellation failed with [errorCode].
final class PatientAppointmentCancelFailure
    extends PatientAppointmentCancelState {
  /// Creates the failure state identified by [errorCode].
  const PatientAppointmentCancelFailure(this.errorCode);

  /// The reason to localize at the presentation boundary.
  final AppointmentErrorCode errorCode;
}
