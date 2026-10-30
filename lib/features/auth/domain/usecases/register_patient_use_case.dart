import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/auth_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/core/usecases/use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/domain/mixins/auth_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_registration.dart';
import 'package:clinic_appointment_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:clinic_appointment_system/features/users/domain/repositories/user_repository.dart';

/// Registers a patient: validates the input, creates the account, then its
/// patient profile.
final class RegisterPatientUseCase
    with AuthInputValidationMixin
    implements UseCase<DataResult<AuthSession>, AuthRegistration> {
  /// Injects the authentication and user profile boundaries.
  const RegisterPatientUseCase(this._repository, this._users);

  final AuthRepository _repository;
  final UserRepository _users;

  /// Returns the sign-up result so callers see the account outcome.
  /// Throws [AuthException] for invalid input or authentication failure, and
  /// [AuthErrorCode.profileCreationFailed] when the account exists but its
  /// profile could not be saved.
  @override
  Future<DataResult<AuthSession>> call(AuthRegistration registration) async {
    ensureValid(registrationError(registration));
    final session = await _repository.signUp(registration);
    final identity = session.data;
    if (session.isNotSuccess || identity == null) {
      return session;
    }
    await _createPatient(identity, registration);
    return session;
  }

  Future<void> _createPatient(
    AuthSession identity,
    AuthRegistration registration,
  ) async {
    try {
      await _users.createPatient(
        Patient(
          id: identity.userId,
          fullName: registration.fullName.trim(),
          email: identity.email,
        ),
      );
    } on UserException {
      throw const AuthException(AuthErrorCode.profileCreationFailed);
    }
  }
}
