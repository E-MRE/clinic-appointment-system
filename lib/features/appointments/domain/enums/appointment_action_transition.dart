import 'package:clinic_appointment_system/features/appointments/domain/actors/appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/domain/results/appointment_result.dart';

/// Delegates each operation to the entity's state-controlled transition.
extension AppointmentActionTransition on AppointmentAction {
  /// Applies this operation using the supplied actor and transaction time.
  AppointmentResult apply(
    Appointment current, {
    required AppointmentActor by,
    required DateTime at,
  }) {
    return switch (this) {
      AppointmentAction.approve => current.approve(by: by, at: at),
      AppointmentAction.reject => current.reject(by: by, at: at),
      AppointmentAction.cancelByPatient => current.cancelByPatient(
        by: by,
        at: at,
      ),
      AppointmentAction.cancelByStaff => current.cancelByStaff(by: by, at: at),
      AppointmentAction.complete => current.complete(by: by, at: at),
      AppointmentAction.markNoShow => current.markNoShow(by: by, at: at),
    };
  }
}
