import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';

/// Request states shared by sign-in, sign-up and password-reset flows.
/// Session changes remain the responsibility of AuthCubit.
sealed class AuthRequestState {
  const AuthRequestState();
}

/// No request has been submitted.
final class AuthRequestInitial extends AuthRequestState {
  const AuthRequestInitial();
}

/// A validated request is in progress.
final class AuthRequestLoading extends AuthRequestState {
  const AuthRequestLoading();
}

/// The repository completed the request successfully.
final class AuthRequestSuccess extends AuthRequestState {
  const AuthRequestSuccess();
}

/// Either a validation/result message or an exception code, never both.
final class AuthRequestFailure extends AuthRequestState {
  const AuthRequestFailure.message(String this.message) : errorCode = null;

  const AuthRequestFailure.code(AuthErrorCode this.errorCode) : message = null;

  final String? message;
  final AuthErrorCode? errorCode;
}
