import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/mixins/auth_validation_mixin.dart';

/// Validates patient registration input and requests an email/password account.
final class SignUpCubit extends AuthRequestCubit with AuthValidationMixin {
  SignUpCubit(this._repository);

  final AuthRepository _repository;

  /// Registers with the sign-up password rules before contacting the repository.
  Future<void> signUp(AuthCredentials credentials) => executeRequest(
    validate: () => validateCredentials(credentials, isSignUp: true),
    request: () => _repository.signUp(credentials),
  );
}
