import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';

/// Session states, separate from sign-in and password-reset form operations.
sealed class AuthState {
  const AuthState();
}

/// The session observer has not started yet.
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Waiting for the provider to restore the persisted session.
final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// A restored or newly authenticated session.
final class AuthSignedIn extends AuthState {
  const AuthSignedIn(this.session);

  final AuthSession session;
}

/// The provider confirmed there is no active session.
final class AuthSignedOut extends AuthState {
  const AuthSignedOut();
}

/// A session failure whose code is translated by the presentation layer.
final class AuthFailure extends AuthState {
  const AuthFailure(this.errorCode);

  final AuthErrorCode errorCode;
}
