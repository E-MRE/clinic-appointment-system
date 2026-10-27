import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/app_exception.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_registration.dart';
import 'package:clinic_appointment_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/mixins/auth_validation_mixin.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:clinic_appointment_system/features/users/domain/repositories/user_repository.dart';

/// Validates patient registration input and requests an email/password account.
final class SignUpCubit extends AuthRequestCubit with AuthValidationMixin {
  SignUpCubit(this._repository, this._users);

  final AuthRepository _repository;
  final UserRepository _users;

  /// Registers with the sign-up password rules before contacting the repository.
  Future<void> signUp(AuthRegistration registration) {
    return executeRequest(
      validate: () => validateRegistration(registration),
      request: () => _signUp(registration),
    );
  }

  /// Creates the account, then its patient profile; returns the sign-up
  /// result so the request state reflects the account outcome.
  Future<Result> _signUp(AuthRegistration registration) async {
    final session = await _repository.signUp(registration);
    final identity = session.data;
    if (session.isNotSuccess || identity == null) {
      return session;
    }
    await _createPatient(identity, registration);
    return session;
  }

  /// Saves the patient profile; a failure leaves the account in place and is
  /// reported as [AuthErrorCode.profileCreationFailed].
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
