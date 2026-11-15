import 'package:clinic_appointment_system/features/appointments/domain/actors/patient_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/results/appointment_result.dart';

/// Evaluates whether a patient may cancel an appointment and returns its reason.
final class PatientAppointmentCancellationPolicy {
  /// Creates a stateless patient cancellation policy.
  const PatientAppointmentCancellationPolicy();

  /// Returns the domain cancellation outcome for [appointment] at [at].
  AppointmentResult evaluate({
    required Appointment appointment,
    required PatientAppointmentActor patient,
    required DateTime at,
  }) {
    return appointment.cancelByPatient(by: patient, at: at);
  }
}
