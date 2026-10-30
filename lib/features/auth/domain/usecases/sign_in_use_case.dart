import 'package:clinic_appointment_system/core/errors/auth_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/domain/mixins/auth_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/auth/domain/repositories/auth_repository.dart';

/// Validates the credentials and signs in with email and password.
final class SignInUseCase
    with AuthInputValidationMixin
    implements UseCase<DataResult<AuthSession>, AuthCredentials> {
  /// Injects the authentication boundary.
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  /// Returns the authenticated session.
  /// Throws [AuthException] for invalid input or authentication failure.
  @override
  Future<DataResult<AuthSession>> call(AuthCredentials credentials) async {
    ensureValid(credentialsError(credentials));
    return _repository.signIn(credentials);
  }
}
