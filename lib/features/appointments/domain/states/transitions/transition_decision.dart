import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';

/// A state's immutable decision, leaving appointment and history creation to the entity.
final class TransitionDecision {
  /// Allows a transition to [next].
  const TransitionDecision.allow(AppointmentStatus this.next)
    : errorCode = null;

  /// Denies a transition with [errorCode].
  const TransitionDecision.deny(AppointmentErrorCode this.errorCode)
    : next = null;

  /// The next status, or null when the transition is denied.
  final AppointmentStatus? next;

  /// The lifecycle failure, or null when the transition is allowed.
  final AppointmentErrorCode? errorCode;

  /// Whether the state allows a transition to the next status.
  bool get isAllowed => next != null;
}
