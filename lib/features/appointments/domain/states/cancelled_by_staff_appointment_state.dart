part of 'appointment_state.dart';

/// Lifecycle behavior for the cancelled by staff status.
final class CancelledByStaffAppointmentState extends AppointmentState {
  /// Creates the immutable cancelled by staff state.
  const CancelledByStaffAppointmentState();

  /// Whether this status occupies its booked slot.
  @override
  bool get occupiesSlot => false;
}
