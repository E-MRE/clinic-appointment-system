import 'package:clinic_appointment_system/features/appointments/domain/actors/appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action_transition.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/appointment_action_too_early_hint.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/appointment_status_staff_actions.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_appointment_action_offer.dart';

/// The actions offered to a staff member for one appointment at one instant.
/// Each candidate is tried on the domain without side effects: allowed
/// actions are enabled, too-early ones are disabled with a hint, and any
/// other refusal leaves the action out.
final class StaffAppointmentActionOffers {
  /// Classifies the candidate actions of [appointment] for [actor] at [at];
  /// nothing is offered without an actor.
  factory StaffAppointmentActionOffers({
    required Appointment appointment,
    required AppointmentActor? actor,
    required DateTime at,
  }) {
    if (actor == null) return StaffAppointmentActionOffers._(const []);
    return StaffAppointmentActionOffers._([
      for (final action in appointment.status.staffActions)
        ?_offer(action, appointment, actor, at),
    ]);
  }

  StaffAppointmentActionOffers._(List<StaffAppointmentActionOffer> offers)
    : offers = List<StaffAppointmentActionOffer>.unmodifiable(offers);

  /// Actions the staff member may take now or after a time boundary.
  final List<StaffAppointmentActionOffer> offers;

  static StaffAppointmentActionOffer? _offer(
    AppointmentAction action,
    Appointment appointment,
    AppointmentActor actor,
    DateTime at,
  ) {
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
