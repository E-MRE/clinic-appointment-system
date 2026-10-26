import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/mixins/auth_validation_mixin.dart';

/// Validates sign-in input and submits it through the authentication boundary.
final class SignInCubit extends AuthRequestCubit with AuthValidationMixin {
  SignInCubit(this._repository);

  final AuthRepository _repository;

  /// Signs in with valid credentials; session changes are observed by AuthCubit.
  Future<void> signIn(AuthCredentials credentials) => executeRequest(
    validate: () => validateCredentials(credentials),
    request: () => _repository.signIn(credentials),
  );
}
