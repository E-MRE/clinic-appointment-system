import 'package:clinic_appointment_system/features/appointments/domain/actors/appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/states/transitions/transition_decision.dart';

/// Contract for states that permit cancelByPatient.
abstract interface class PatientCancellableState {
  /// Implementations must decide whether [by] may perform cancelByPatient at [at].
  /// Returns the next status or a lifecycle error without changing [appointment].
  TransitionDecision cancelByPatient(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  });
}
