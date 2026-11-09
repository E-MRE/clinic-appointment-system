import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';

/// The closed set of states of an appointment request.
sealed class BookAppointmentState {
  /// Creates a request state.
  const BookAppointmentState();
}

/// No request has been sent.
final class BookAppointmentIdle extends BookAppointmentState {
  /// Creates the idle state.
  const BookAppointmentIdle();
}

/// A request is running.
final class BookAppointmentInProgress extends BookAppointmentState {
  /// Creates the in-progress state.
  const BookAppointmentInProgress();
}

/// The request was stored as [appointment].
final class BookAppointmentSuccess extends BookAppointmentState {
  /// Creates the success state holding the stored [appointment].
  const BookAppointmentSuccess(this.appointment);

  /// The stored, pending appointment.
  final Appointment appointment;
}

/// The request failed with [errorCode].
final class BookAppointmentFailure extends BookAppointmentState {
  /// Creates the failure state identified by [errorCode].
  const BookAppointmentFailure(this.errorCode);

  /// The reason to localize at the presentation boundary.
  final AppointmentErrorCode errorCode;
}
