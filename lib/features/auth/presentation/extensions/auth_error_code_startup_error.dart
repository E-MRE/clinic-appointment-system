import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/features/auth/presentation/enums/startup_error_kind.dart';

/// Resolves the startup error shown for a session failure.
extension AuthErrorCodeStartupError on AuthErrorCode {
  /// The startup error variant for this code.
  StartupErrorKind get startupErrorKind {
    if (this == AuthErrorCode.networkRequestFailed) {
      return StartupErrorKind.offline;
    }
    return StartupErrorKind.failure;
  }
}
