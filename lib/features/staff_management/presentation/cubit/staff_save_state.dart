import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';

/// The closed set of progress and result states for staff save requests.
sealed class StaffSaveState {
  /// Creates a staff save state.
  const StaffSaveState();
}

/// No staff save request has started.
final class StaffSaveInitial extends StaffSaveState {
  /// Creates the initial request state.
  const StaffSaveInitial();
}

/// A staff save request is in progress.
final class StaffSaveSaving extends StaffSaveState {
  /// Creates a saving state.
  const StaffSaveSaving();
}

/// A staff save request completed successfully.
final class StaffSaveSaved extends StaffSaveState {
  /// Creates a saved state containing the persisted profile.
  const StaffSaveSaved(this.staff);

  /// The profile returned by the use case.
  final Staff staff;
}

/// Account provisioning failed with an authentication code.
final class StaffSaveAuthFailure extends StaffSaveState {
  /// Creates an authentication failure state.
  const StaffSaveAuthFailure(this.code);

  /// The account failure reason to localize in the UI.
  final AuthErrorCode code;
}

/// Profile validation or persistence failed with a user code.
final class StaffSaveProfileFailure extends StaffSaveState {
  /// Creates a profile failure state.
  const StaffSaveProfileFailure(this.code);

  /// The profile failure reason to localize in the UI.
  final UserErrorCode code;
}
