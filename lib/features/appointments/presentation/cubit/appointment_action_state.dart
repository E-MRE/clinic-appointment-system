import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';

/// The closed set of states of a single appointment lifecycle request.
sealed class AppointmentActionState {
  /// Creates a lifecycle request state.
  const AppointmentActionState();
}

/// No request has been made.
final class AppointmentActionIdle extends AppointmentActionState {
  /// Creates the idle state.
  const AppointmentActionIdle();
}

/// A request for the appointment identified by [appointmentId] is running.
final class AppointmentActionInProgress extends AppointmentActionState {
  /// Creates the in-progress state of one appointment.
  const AppointmentActionInProgress(this.appointmentId);

  /// The appointment the running request changes.
  final String appointmentId;
}

/// The appointment's status was changed.
final class AppointmentActionSuccess extends AppointmentActionState {
  /// Creates the success state.
  const AppointmentActionSuccess();
}

/// The request failed with [errorCode].
final class AppointmentActionFailure extends AppointmentActionState {
  /// Creates the failure state identified by [errorCode].
  const AppointmentActionFailure(this.errorCode);

  /// The reason to localize at the presentation boundary.
  final AppointmentErrorCode errorCode;
}
