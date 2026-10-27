import 'package:clinic_appointment_system/core/errors/app_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/auth/domain/repositories/auth_repository.dart';

/// Signs in with email and password.
final class SignInUseCase
    implements UseCase<DataResult<AuthSession>, AuthCredentials> {
  /// Injects the authentication boundary.
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  /// Returns the authenticated session.
  /// Throws [AuthException] on authentication failure.
  @override
  Future<DataResult<AuthSession>> call(AuthCredentials credentials) {
    return _repository.signIn(credentials);
  }
}
