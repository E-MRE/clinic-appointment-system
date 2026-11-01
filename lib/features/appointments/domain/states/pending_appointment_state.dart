part of 'appointment_state.dart';

/// Lifecycle behavior for the pending status.
final class PendingAppointmentState extends AppointmentState
    implements ApprovableState, RejectableState, PatientCancellableState {
  /// Creates the immutable pending state.
  const PendingAppointmentState();

  /// Whether this status occupies its booked slot.
  @override
  bool get occupiesSlot => true;

  /// The capability to approve in this state.
  @override
  ApprovableState get approvable => this;

  /// The capability to reject in this state.
  @override
  RejectableState get rejectable => this;

  /// The capability to cancelByPatient in this state.
  @override
  PatientCancellableState get patientCancellable => this;

  /// Decides whether to transition to approved.
  @override
  TransitionDecision approve(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  }) {
    final error = _permissionError(by.mayActAsStaff(appointment.staffId));
    return _decide(AppointmentStatus.approved, error);
  }

  /// Decides whether to transition to rejected.
  @override
  TransitionDecision reject(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  }) {
    final error = _permissionError(by.mayActAsStaff(appointment.staffId));
    return _decide(AppointmentStatus.rejected, error);
  }

  /// Decides whether to transition to cancelledByPatient.
  @override
  TransitionDecision cancelByPatient(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  }) => _cancelForPatient(appointment, by, at);
}
