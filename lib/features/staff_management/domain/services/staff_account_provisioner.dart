import 'package:clinic_appointment_system/core/errors/auth_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';

/// Account boundary implemented with an isolated sign-in session.
/// Implementations must never change the caller's own session.
abstract interface class StaffAccountProvisioner {
  /// Implementations must create the account and call [completeProfile] with
  /// its uid. Success data is that uid. Account creation throws [AuthException].
  /// If [completeProfile] throws, delete the new account and rethrow the original
  /// error; if deletion also fails, throw [UserException] with
  /// [UserErrorCode.orphanAccount]. Always sign the isolated session out.
  Future<DataResult<String>> provision(
    AuthCredentials credentials, {
    required Future<void> Function(String uid) completeProfile,
  });
}
