import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';

/// A staff lifecycle action that is currently allowed or waiting for its time boundary.
final class StaffAppointmentActionOffer {
  /// Creates an available action with its enabled state and optional hint.
  const StaffAppointmentActionOffer({
    required this.action,
    required this.isEnabled,
    this.hint,
  });

  /// The domain lifecycle action represented by this offer.
  final AppointmentAction action;

  /// Whether the action can be submitted at the current time.
  final bool isEnabled;

  /// Explanation shown when the action is temporarily disabled.
  final String? hint;
}
