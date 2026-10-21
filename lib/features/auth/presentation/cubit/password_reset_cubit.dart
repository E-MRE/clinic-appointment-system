import 'package:clinic_appointment_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/mixins/auth_validation_mixin.dart';

/// Validates an email address and requests the password-reset email.
final class PasswordResetCubit extends AuthRequestCubit
    with AuthValidationMixin {
  PasswordResetCubit(this._repository);

  final AuthRepository _repository;

  /// Requests a reset email without changing the application's session state.
  Future<void> sendPasswordResetEmail(String email) => executeRequest(
    validate: () => validateEmail(email),
    request: () => _repository.sendPasswordResetEmail(email),
  );
}
