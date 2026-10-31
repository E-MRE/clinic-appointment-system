import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:equatable/equatable.dart';

/// The closed set of progress and result states for availability window requests.
/// Variants must expose the values defining their state identity.
sealed class AvailabilityWindowSaveState extends Equatable {
  /// Creates an availability window request state.
  const AvailabilityWindowSaveState();
}

/// No availability window request has started.
final class AvailabilityWindowSaveInitial extends AvailabilityWindowSaveState {
  /// Creates the initial request state.
  const AvailabilityWindowSaveInitial();

  /// Initial state has no associated values.
  @override
  List<Object?> get props => [];
}

/// An add or remove request is in progress.
final class AvailabilityWindowSaving extends AvailabilityWindowSaveState {
  /// Creates the saving state.
  const AvailabilityWindowSaving();

  /// Saving has no associated values.
  @override
  List<Object?> get props => [];
}

/// An availability window request completed successfully.
final class AvailabilityWindowSaved extends AvailabilityWindowSaveState {
  /// Creates a saved state containing the persisted schedule.
  const AvailabilityWindowSaved(this.availability);

  /// The schedule returned by the use case.
  final StaffAvailability availability;

  /// The saved schedule defining value identity.
  @override
  List<Object?> get props => [availability];
}

/// An availability window request failed with a domain code.
final class AvailabilityWindowSaveFailure extends AvailabilityWindowSaveState {
  /// Creates a failure, retaining the existing window for an overlap.
  const AvailabilityWindowSaveFailure(this.code, {this.conflict});

  /// The reason to localize at the presentation boundary.
  final AvailabilityErrorCode code;

  /// The existing window causing an overlap, when supplied by the domain.
  final AvailabilityWindow? conflict;

  /// The failure code and optional conflict defining value identity.
  @override
  List<Object?> get props => [code, conflict];
}
