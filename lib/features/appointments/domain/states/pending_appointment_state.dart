part of 'appointment_state.dart';

/// Lifecycle behavior for the pending status.
final class PendingAppointmentState extends AppointmentState {
  /// Creates the immutable pending state.
  const PendingAppointmentState();

  /// Whether this status occupies its booked slot.
  @override
  bool get occupiesSlot => true;

  /// Allows the transition to approved.
  @override
  AppointmentStatus approve(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  }) {
    _requirePermission(by.mayActAsStaff(appointment.staffId));
    return AppointmentStatus.approved;
  }

  /// Allows the transition to rejected.
  @override
  AppointmentStatus reject(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  }) {
    _requirePermission(by.mayActAsStaff(appointment.staffId));
    return AppointmentStatus.rejected;
  }

  /// Allows the transition to cancelledByPatient.
  @override
  AppointmentStatus cancelByPatient(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  }) => _cancelForPatient(appointment, by, at);
}
