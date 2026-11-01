part of 'appointment_state.dart';

/// Lifecycle behavior for the approved status.
final class ApprovedAppointmentState extends AppointmentState
    implements
        PatientCancellableState,
        StaffCancellableState,
        CompletableState,
        NoShowMarkableState {
  /// Creates the immutable approved state.
  const ApprovedAppointmentState();

  /// Whether this status occupies its booked slot.
  @override
  bool get occupiesSlot => true;

  /// The capability to cancelByPatient in this state.
  @override
  PatientCancellableState get patientCancellable => this;

  /// The capability to cancelByStaff in this state.
  @override
  StaffCancellableState get staffCancellable => this;

  /// The capability to complete in this state.
  @override
  CompletableState get completable => this;

  /// The capability to markNoShow in this state.
  @override
  NoShowMarkableState get noShowMarkable => this;

  /// Decides whether to transition to cancelledByPatient.
  @override
  TransitionDecision cancelByPatient(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  }) => _cancelForPatient(appointment, by, at);

  /// Decides whether to transition to cancelledByStaff.
  @override
  TransitionDecision cancelByStaff(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  }) {
    final error = _permissionError(by.mayActAsStaff(appointment.staffId));
    return _decide(AppointmentStatus.cancelledByStaff, error);
  }

  /// Decides whether to transition to completed.
  @override
  TransitionDecision complete(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  }) {
    final error =
        _permissionError(by.mayActAsStaff(appointment.staffId)) ??
        _reachedError(at, appointment.startsAt);
    return _decide(AppointmentStatus.completed, error);
  }

  /// Decides whether to transition to noShow.
  @override
  TransitionDecision markNoShow(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  }) {
    final earliest = appointment.startsAt.add(
      const Duration(minutes: AppointmentConstants.noShowToleranceMinutes),
    );
    final error =
        _permissionError(by.mayMarkNoShow(appointment.staffId)) ??
        _reachedError(at, earliest);
    return _decide(AppointmentStatus.noShow, error);
  }
}
