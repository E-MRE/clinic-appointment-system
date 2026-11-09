import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';

/// The closed set of states of the staff member's pending requests.
sealed class StaffRequestsState {
  /// Creates a request list state.
  const StaffRequestsState();
}

/// Waiting for the first appointment list.
final class StaffRequestsLoading extends StaffRequestsState {
  /// Creates the loading state.
  const StaffRequestsLoading();
}

/// The observation failed with [errorCode].
final class StaffRequestsFailure extends StaffRequestsState {
  /// Creates the failure state identified by [errorCode].
  const StaffRequestsFailure(this.errorCode);

  /// The reason to localize at the presentation boundary.
  final AppointmentErrorCode errorCode;
}

/// The latest pending requests.
final class StaffRequestsLoaded extends StaffRequestsState {
  /// Creates the loaded state holding [requests].
  const StaffRequestsLoaded(this.requests);

  /// Pending appointments ordered by start.
  final List<Appointment> requests;
}
