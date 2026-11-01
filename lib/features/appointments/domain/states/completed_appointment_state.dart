part of 'appointment_state.dart';

/// Lifecycle behavior for the completed status.
final class CompletedAppointmentState extends AppointmentState {
  /// Creates the immutable completed state.
  const CompletedAppointmentState();

  /// Whether this status occupies its booked slot.
  @override
  bool get occupiesSlot => true;
}
