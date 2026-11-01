part of 'appointment_state.dart';

/// Lifecycle behavior for the no show status.
final class NoShowAppointmentState extends AppointmentState {
  /// Creates the immutable no show state.
  const NoShowAppointmentState();

  /// Whether this status occupies its booked slot.
  @override
  bool get occupiesSlot => true;
}
