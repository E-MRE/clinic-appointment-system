import 'package:clinic_appointment_system/features/appointments/domain/actors/appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/states/transitions/transition_decision.dart';

/// Contract for states that permit cancelByStaff.
abstract interface class StaffCancellableState {
  /// Implementations must decide whether [by] may perform cancelByStaff at [at].
  /// Returns the next status or a lifecycle error without changing [appointment].
  TransitionDecision cancelByStaff(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  });
}
