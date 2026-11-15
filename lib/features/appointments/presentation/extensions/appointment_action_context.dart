import 'package:clinic_appointment_system/features/appointments/domain/actors/appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/cubit/appointment_action_cubit.dart';
import 'package:flutter/widgets.dart';

/// Performs appointment lifecycle actions through one shared presentation seam.
extension AppointmentActionContext on BuildContext {
  /// Applies [cubit] to [appointment] with the supplied domain actor.
  Future<void> performAppointmentAction(
    AppointmentActionCubit cubit,
    Appointment appointment,
    AppointmentActor actor, {
    String? reason,
  }) async {
    await cubit.perform(appointment, by: actor, reason: reason);
  }
}
