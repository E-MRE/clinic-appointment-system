import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';

/// The closed set of states of the patient's appointment observation.
sealed class PatientAppointmentsState {
  /// Creates an appointment observation state.
  const PatientAppointmentsState();
}

/// Waiting for the first appointment list.
final class PatientAppointmentsLoading extends PatientAppointmentsState {
  /// Creates the loading state.
  const PatientAppointmentsLoading();
}

/// The observation failed with [errorCode].
final class PatientAppointmentsFailure extends PatientAppointmentsState {
  /// Creates the failure state identified by [errorCode].
  const PatientAppointmentsFailure(this.errorCode);

  /// The reason to localize at the presentation boundary.
  final AppointmentErrorCode errorCode;
}

/// The latest list of the patient's appointments.
final class PatientAppointmentsLoaded extends PatientAppointmentsState {
  /// Creates the loaded state holding [appointments].
  const PatientAppointmentsLoaded(this.appointments);

  /// The patient's appointments in stored order.
  final List<Appointment> appointments;
}
