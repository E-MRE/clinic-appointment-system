import 'package:clinic_appointment_system/features/auth/domain/usecases/send_password_reset_email_use_case.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/mixins/auth_validation_mixin.dart';

/// Validates an email address and requests the password-reset email.
final class PasswordResetCubit extends AuthRequestCubit
    with AuthValidationMixin {
  PasswordResetCubit(this._sendPasswordResetEmail);

  final SendPasswordResetEmailUseCase _sendPasswordResetEmail;

  /// Requests a reset email without changing the application's session state.
  Future<void> sendPasswordResetEmail(String email) => executeRequest(
    validate: () => validateEmail(email),
    request: () => _sendPasswordResetEmail(email),
  );
}
