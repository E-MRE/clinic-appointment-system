import 'package:clinic_appointment_system/features/appointments/domain/actors/appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/appointment_action_offer.dart';
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
    final offers = <StaffAppointmentActionOffer>[];
    for (final action in appointment.status.staffActions) {
      final offer = action.offerFor(appointment, actor: actor, at: at);
      if (offer != null) offers.add(offer);
    }
    return StaffAppointmentActionOffers._(offers);
  }

  StaffAppointmentActionOffers._(List<StaffAppointmentActionOffer> offers)
    : offers = List<StaffAppointmentActionOffer>.unmodifiable(offers);

  /// Actions the staff member may take now or after a time boundary.
  final List<StaffAppointmentActionOffer> offers;
}
