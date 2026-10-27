import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_cubit.dart';

/// Submits sign-in credentials through the sign-in use case.
final class SignInCubit extends AuthRequestCubit {
  SignInCubit(this._signIn);

  final SignInUseCase _signIn;

  /// Signs in; session changes are observed by AuthCubit.
  Future<void> signIn(AuthCredentials credentials) {
    return executeRequest(() => _signIn(credentials));
  }
}
