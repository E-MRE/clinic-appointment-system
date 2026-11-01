part of 'appointment_state.dart';

/// Lifecycle behavior for the rejected status.
final class RejectedAppointmentState extends AppointmentState {
  /// Creates the immutable rejected state.
  const RejectedAppointmentState();

  /// Whether this status occupies its booked slot.
  @override
  bool get occupiesSlot => false;
}
