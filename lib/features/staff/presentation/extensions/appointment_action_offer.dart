import 'package:clinic_appointment_system/features/appointments/domain/actors/appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action_transition.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/appointment_action_too_early_hint.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_appointment_action_offer.dart';

/// Projects an appointment action result into a staff-facing offer.
extension AppointmentActionOffer on AppointmentAction {
  /// Returns the staff offer, or null when the action is refused for [actor].
  StaffAppointmentActionOffer? offerFor(
    Appointment appointment, {
    required AppointmentActor actor,
    required DateTime at,
  }) {
    final result = apply(appointment, by: actor, at: at);
    if (result.isSuccess) {
      return StaffAppointmentActionOffer(action: this, isEnabled: true);
    }
    if (result.errorCode != AppointmentErrorCode.tooEarly) return null;
    return StaffAppointmentActionOffer(
      action: this,
      isEnabled: false,
      hint: tooEarlyHint(appointment),
    );
  }
}
