import 'package:clinic_appointment_system/features/appointments/domain/actors/appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/states/transitions/transition_decision.dart';

/// Contract for states that permit reject.
abstract interface class RejectableState {
  /// Implementations must decide whether [by] may perform reject at [at].
  /// Returns the next status or a lifecycle error without changing [appointment].
  TransitionDecision reject(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  });
}
