import 'package:clinic_appointment_system/features/appointments/domain/actors/appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';

/// A lifecycle operation applied to the appointment read in the transaction.
final class AppointmentStatusRequest {
  /// Identifies the appointment, requested operation and acting user.
  const AppointmentStatusRequest({
    required this.appointmentId,
    required this.action,
    required this.by,
  });

  final String appointmentId;
  final AppointmentAction action;
  final AppointmentActor by;
}
