part of 'appointment_state.dart';

/// Lifecycle behavior for the cancelled by patient status.
final class CancelledByPatientAppointmentState extends AppointmentState {
  /// Creates the immutable cancelled by patient state.
  const CancelledByPatientAppointmentState();

  /// Whether this status occupies its booked slot.
  @override
  bool get occupiesSlot => false;
}
