import 'package:clinic_appointment_system/features/auth/presentation/enums/startup_error_kind.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';

/// Resolves the startup error shown for a profile failure.
extension UserErrorCodeStartupError on UserErrorCode {
  /// The startup error variant for this code.
  StartupErrorKind get startupErrorKind {
    return switch (this) {
      UserErrorCode.profileMissing => StartupErrorKind.profileMissing,
      UserErrorCode.invalidProfile => StartupErrorKind.invalidProfile,
      // Staff input codes are never emitted while a profile is watched.
      UserErrorCode.unavailable ||
      UserErrorCode.fullNameRequired ||
      UserErrorCode.invalidEmail ||
      UserErrorCode.branchRequired ||
      UserErrorCode.departmentRequired ||
      UserErrorCode.specialtyRequired ||
      UserErrorCode.duplicateService ||
      UserErrorCode.tooManyServices ||
      UserErrorCode.ineligibleService ||
      UserErrorCode.orphanAccount => StartupErrorKind.profileUnavailable,
    };
  }
}
