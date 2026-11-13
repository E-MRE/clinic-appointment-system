import 'package:clinic_appointment_system/features/staff/presentation/models/staff_workspace.dart';
import 'package:equatable/equatable.dart';

/// The closed set of states of the staff member's workspace observation.
sealed class StaffWorkspaceState extends Equatable {
  /// Creates a workspace observation state.
  const StaffWorkspaceState();

  /// The latest workspace snapshot, or null when not loaded.
  StaffWorkspace? get workspace => null;

  @override
  List<Object?> get props => [];
}

/// Waiting for every workspace component to arrive.
final class StaffWorkspaceLoading extends StaffWorkspaceState {
  /// Creates the loading state.
  const StaffWorkspaceLoading();
}

/// A workspace component could not be observed.
final class StaffWorkspaceFailure extends StaffWorkspaceState {
  /// Creates the failure state.
  const StaffWorkspaceFailure();
}

/// Every component arrived; [workspace] is their latest snapshot.
final class StaffWorkspaceLoaded extends StaffWorkspaceState {
  /// Creates the loaded state holding [workspace].
  const StaffWorkspaceLoaded(this.workspace);

  @override
  final StaffWorkspace workspace;

  @override
  List<Object?> get props => [workspace];
}
