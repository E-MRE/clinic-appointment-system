import 'package:clinic_appointment_system/core/errors/app_exception.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:clinic_appointment_system/core/usecases/use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/repositories/auth_repository.dart';

/// Requests a password-reset email.
final class SendPasswordResetEmailUseCase implements UseCase<Result, String> {
  /// Injects the authentication boundary.
  const SendPasswordResetEmailUseCase(this._repository);

  final AuthRepository _repository;

  /// Acknowledges the request without confirming that the account exists.
  /// Throws [AuthException] if the request fails.
  @override
  Future<Result> call(String email) {
    return _repository.sendPasswordResetEmail(email);
  }
}
