import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';

/// The closed set of states of the staff member's watched appointments.
sealed class StaffAppointmentsState {
  /// Creates an appointments observation state.
  const StaffAppointmentsState();

  /// All observed appointments in the lookback/lookahead window.
  List<Appointment> get appointments => const [];

  /// Derived pending requests scheduled at or after now.
  List<Appointment> get pendingRequests => const [];
}

/// Waiting for the first appointment list.
final class StaffAppointmentsLoading extends StaffAppointmentsState {
  /// Creates the loading state.
  const StaffAppointmentsLoading();
}

/// The observation failed with [errorCode].
final class StaffAppointmentsFailure extends StaffAppointmentsState {
  /// Creates the failure state identified by [errorCode].
  const StaffAppointmentsFailure(this.errorCode);

  /// The reason to localize at the presentation boundary.
  final AppointmentErrorCode errorCode;
}

/// The latest watched appointments and the pending requests derived from
/// them when they arrived.
final class StaffAppointmentsLoaded extends StaffAppointmentsState {
  /// Creates the loaded state.
  const StaffAppointmentsLoaded({
    required this.appointments,
    required this.pendingRequests,
  });

  @override
  final List<Appointment> appointments;

  @override
  final List<Appointment> pendingRequests;
}
