import 'package:clinic_appointment_system/features/appointments/domain/actors/appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action_transition.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/appointment_action_too_early_hint.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_appointment_action_offer.dart';

/// Maps domain lifecycle transitions to enabled, refused, or time-limited staff offers.
final class StaffAppointmentActionOfferPolicy {
  /// Creates the stateless staff action offer policy.
  const StaffAppointmentActionOfferPolicy();

  /// Applies [action] for [actor] at [at] and maps its result to a staff offer.
  ///
  /// Returns null for refused transitions, an enabled offer for successful
  /// transitions, and a disabled offer with a hint when the transition is too
  /// early.
  StaffAppointmentActionOffer? offerFor(
    AppointmentAction action,
    Appointment appointment, {
    required AppointmentActor actor,
    required DateTime at,
  }) {
    final result = action.apply(appointment, by: actor, at: at);
    if (result.isSuccess) {
      return StaffAppointmentActionOffer(action: action, isEnabled: true);
    }
    if (result.errorCode != AppointmentErrorCode.tooEarly) return null;
    return StaffAppointmentActionOffer(
      action: action,
      isEnabled: false,
      hint: action.tooEarlyHint(appointment),
    );
  }
}
