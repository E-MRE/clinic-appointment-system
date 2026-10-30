import 'package:clinic_appointment_system/core/errors/auth_exception.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:clinic_appointment_system/core/usecases/use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/mixins/auth_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/auth/domain/repositories/auth_repository.dart';

/// Validates the email address and requests a password-reset email.
final class SendPasswordResetEmailUseCase
    with AuthInputValidationMixin
    implements UseCase<Result, String> {
  /// Injects the authentication boundary.
  const SendPasswordResetEmailUseCase(this._repository);

  final AuthRepository _repository;

  /// Acknowledges the request without confirming that the account exists.
  /// Throws [AuthException] for an invalid address or a failed request.
  @override
  Future<Result> call(String email) async {
    ensureValid(emailError(email));
    return _repository.sendPasswordResetEmail(email);
  }
}
