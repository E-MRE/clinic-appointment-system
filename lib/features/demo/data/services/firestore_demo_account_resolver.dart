import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/features/demo/data/models/demo_account_emails.dart';
import 'package:clinic_appointment_system/features/demo/domain/enums/demo_error_code.dart';
import 'package:clinic_appointment_system/features/demo/domain/models/demo_accounts.dart';
import 'package:clinic_appointment_system/features/demo/domain/repositories/demo_account_resolver.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/repositories/staff_repository.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:clinic_appointment_system/features/users/domain/repositories/user_repository.dart';

/// Resolves the configured doctor from staff data and patient from user data.
final class FirestoreDemoAccountResolver implements DemoAccountResolver {
  /// Injects the existing profile sources and the configured login emails.
  const FirestoreDemoAccountResolver(
    this._staffRepository,
    this._userRepository,
    this._emails,
  );

  final StaffRepository _staffRepository;
  final UserRepository _userRepository;
  final DemoAccountEmails _emails;

  @override
  Future<DataResult<DemoAccounts>> resolve() async {
    try {
      final staffResult = await _staffRepository.watchStaff().first;
      final staffMembers = staffResult.data;
      if (staffResult.isNotSuccess || staffMembers == null) {
        return DataResult.error(
          errorCode: _mapUserError(staffResult.errorCode),
        );
      }
      final doctors = staffMembers
          .where(
            (Staff profile) =>
                profile.role == UserRole.doctor &&
                _matchesEmail(profile.email, _emails.doctor),
          )
          .toList();
      if (doctors.isEmpty) {
        return const DataResult.error(
          errorCode: DemoErrorCode.doctorAccountMissing,
        );
      }
      if (doctors.length > _singleAccountCount) {
        return const DataResult.error(
          errorCode: DemoErrorCode.linkedAccountAmbiguous,
        );
      }

      final patientResult = await _userRepository.findUserByEmail(
        _emails.patient,
      );
      if (patientResult.isNotSuccess) {
        return DataResult.error(
          errorCode: _mapPatientError(patientResult.errorCode),
        );
      }
      final patient = patientResult.data;
      if (patient == null) {
        return const DataResult.error(
          errorCode: DemoErrorCode.patientAccountMissing,
        );
      }
      if (patient.role != UserRole.patient) {
        return const DataResult.error(
          errorCode: DemoErrorCode.linkedAccountRoleMismatch,
        );
      }

      final doctor = doctors.first;
      return DataResult.success(
        data: DemoAccounts(
          doctorUid: doctor.id,
          doctorFullName: doctor.fullName,
          doctorEmail: doctor.email,
          patientUid: patient.id,
          patientFullName: patient.fullName,
          patientEmail: patient.email,
        ),
      );
    } catch (error) {
      return DataResult.error(errorCode: _mapUserError(_userErrorCode(error)));
    }
  }

  int get _singleAccountCount => 1;

  bool _matchesEmail(String profileEmail, String configuredEmail) {
    return profileEmail.trim().toLowerCase() ==
        configuredEmail.trim().toLowerCase();
  }

  DemoErrorCode _mapPatientError(Enum? code) {
    if (code == UserErrorCode.profileMissing) {
      return DemoErrorCode.patientAccountMissing;
    }
    if (code == UserErrorCode.invalidProfile) {
      return DemoErrorCode.invalidAccountProfile;
    }
    return DemoErrorCode.unavailable;
  }

  DemoErrorCode _mapUserError(Enum? code) {
    if (code == UserErrorCode.invalidProfile) {
      return DemoErrorCode.invalidAccountProfile;
    }
    return DemoErrorCode.unavailable;
  }

  UserErrorCode? _userErrorCode(Object error) {
    if (error is UserException) return error.code;
    return null;
  }
}
