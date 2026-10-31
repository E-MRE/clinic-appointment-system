import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/services/staff_account_provisioner.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';

final class FakeStaffAccountProvisioner implements StaffAccountProvisioner {
  DataResult<String> result = const DataResult.success(data: 'new-uid');
  AuthCredentials? receivedCredentials;
  Object? creationException;
  bool deleteFails = false;
  int provisionCalls = 0;
  final List<String> deletedUids = [];
  bool signedOut = false;

  @override
  Future<DataResult<String>> provision(
    AuthCredentials credentials, {
    required Future<void> Function(String uid) completeProfile,
  }) async {
    provisionCalls++;
    receivedCredentials = credentials;
    try {
      if (creationException case final Object error) {
        throw error;
      }
      final String? uid = result.data;
      if (result.isNotSuccess || uid == null) {
        return result;
      }
      try {
        await completeProfile(uid);
      } catch (_) {
        if (deleteFails) {
          throw const UserException(UserErrorCode.orphanAccount);
        }
        deletedUids.add(uid);
        rethrow;
      }
      return result;
    } finally {
      signedOut = true;
    }
  }
}
