import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/auth_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/features/auth/domain/mappers/auth_exception_mapper.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/staff_management/data/services/secondary_auth_provider.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/services/staff_account_provisioner.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Creates staff accounts through an isolated Firebase authentication session.
final class FirebaseStaffAccountProvisioner implements StaffAccountProvisioner {
  /// Injects secondary authentication and provider error translation.
  const FirebaseStaffAccountProvisioner(this._provider, this._exceptionMapper);

  final SecondaryAuthProvider _provider;
  final AuthExceptionMapper _exceptionMapper;

  /// Creates the isolated account, completes its profile and signs out.
  /// Rolls back failed profiles, preserving the original error unless deletion
  /// fails; sign-out failures never replace the primary outcome.
  @override
  Future<DataResult<String>> provision(
    AuthCredentials credentials, {
    required Future<void> Function(String uid) completeProfile,
  }) async {
    final FirebaseAuth auth = await _executeAuth(_provider.auth);
    try {
      final UserCredential credential = await _executeAuth(() {
        return auth.createUserWithEmailAndPassword(
          email: credentials.email.trim(),
          password: credentials.password,
        );
      });
      final User? user = credential.user;
      if (user == null) {
        throw const AuthException(AuthErrorCode.unexpected);
      }
      final String uid = user.uid;
      try {
        await completeProfile(uid);
      } catch (error, stackTrace) {
        try {
          await user.delete();
        } catch (_, deleteStackTrace) {
          Error.throwWithStackTrace(
            const UserException(UserErrorCode.orphanAccount),
            deleteStackTrace,
          );
        }
        Error.throwWithStackTrace(error, stackTrace);
      }
      return DataResult.success(data: uid);
    } finally {
      try {
        await auth.signOut();
      } catch (_) {
        // Cleanup must never replace the provisioning result or original error.
      }
    }
  }

  Future<T> _executeAuth<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(_exceptionMapper.map(error), stackTrace);
    }
  }
}
