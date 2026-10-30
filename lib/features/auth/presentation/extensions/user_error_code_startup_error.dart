import 'package:clinic_appointment_system/features/auth/presentation/enums/startup_error_kind.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';

/// Resolves the startup error shown for a profile failure.
extension UserErrorCodeStartupError on UserErrorCode {
  /// The startup error variant for this code.
  StartupErrorKind get startupErrorKind {
    return switch (this) {
      UserErrorCode.profileMissing => StartupErrorKind.profileMissing,
      UserErrorCode.invalidProfile => StartupErrorKind.invalidProfile,
      UserErrorCode.unavailable => StartupErrorKind.profileUnavailable,
    };
  }
}
