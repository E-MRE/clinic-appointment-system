import 'package:clinic_appointment_system/features/auth/domain/usecases/send_password_reset_email_use_case.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_cubit.dart';

/// Requests the password-reset email through its use case.
final class PasswordResetCubit extends AuthRequestCubit {
  PasswordResetCubit(this._sendPasswordResetEmail);

  final SendPasswordResetEmailUseCase _sendPasswordResetEmail;

  /// Requests a reset email without changing the application's session state.
  Future<void> sendPasswordResetEmail(String email) {
    return executeRequest(() => _sendPasswordResetEmail(email));
  }
}
