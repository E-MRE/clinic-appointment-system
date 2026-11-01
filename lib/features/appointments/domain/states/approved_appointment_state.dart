part of 'appointment_state.dart';

/// Lifecycle behavior for the approved status.
final class ApprovedAppointmentState extends AppointmentState {
  /// Creates the immutable approved state.
  const ApprovedAppointmentState();

  /// Whether this status occupies its booked slot.
  @override
  bool get occupiesSlot => true;

  /// Allows the transition to cancelledByPatient.
  @override
  AppointmentStatus cancelByPatient(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  }) => _cancelForPatient(appointment, by, at);

  /// Allows the transition to cancelledByStaff.
  @override
  AppointmentStatus cancelByStaff(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  }) {
    _requirePermission(by.mayActAsStaff(appointment.staffId));
    return AppointmentStatus.cancelledByStaff;
  }

  /// Allows the transition to completed.
  @override
  AppointmentStatus complete(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  }) {
    _requirePermission(by.mayActAsStaff(appointment.staffId));
    _requireReached(at, appointment.startsAt);
    return AppointmentStatus.completed;
  }

  /// Allows the transition to noShow.
  @override
  AppointmentStatus markNoShow(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  }) {
    _requirePermission(by.mayMarkNoShow(appointment.staffId));
    final earliest = appointment.startsAt.add(
      const Duration(minutes: AppointmentConstants.noShowToleranceMinutes),
    );
    _requireReached(at, earliest);
    return AppointmentStatus.noShow;
  }
}
