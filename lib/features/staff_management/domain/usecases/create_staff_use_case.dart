import 'package:clinic_appointment_system/core/errors/auth_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/core/usecases/use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/mixins/auth_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/mixins/staff_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/models/staff_assignment.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/models/staff_registration.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/repositories/staff_repository.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/services/staff_account_provisioner.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// Validates staff input and provisions an account with its profile.
final class CreateStaffUseCase
    with AuthInputValidationMixin, StaffInputValidationMixin
    implements UseCase<DataResult<Staff>, StaffRegistration> {
  /// Injects isolated account provisioning and staff persistence boundaries.
  const CreateStaffUseCase(this._provisioner, this._repository);

  final StaffAccountProvisioner _provisioner;
  final StaffRepository _repository;

  /// Trims profile input, validates credentials and assignments, then provisions.
  /// Throws [AuthException] for invalid credentials or account creation failure.
  /// Throws [UserException] for invalid staff, profile failure or failed rollback.
  @override
  Future<DataResult<Staff>> call(StaffRegistration registration) async {
    final Staff trimmed = registration.staff.trimmed();
    final AuthCredentials credentials = AuthCredentials(
      email: trimmed.email,
      password: registration.password,
    );
    ensureValid(credentialsError(credentials, isSignUp: true));
    ensureStaffValid(
      staffError(
        StaffAssignment(
          staff: trimmed,
          availableServices: registration.availableServices,
        ),
      ),
    );
    final DataResult<String> result = await _provisioner.provision(
      credentials,
      completeProfile: (String uid) async {
        await _repository.createStaff(trimmed.withId(uid));
      },
    );
    final String? uid = result.data;
    if (result.isNotSuccess || uid == null) {
      return DataResult.error(message: result.message);
    }
    return DataResult.success(data: trimmed.withId(uid));
  }
}
