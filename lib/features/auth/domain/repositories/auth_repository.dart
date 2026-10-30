import 'package:clinic_appointment_system/core/errors/auth_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_registration.dart';

/// Authentication boundary. Success uses results; authentication failures throw
/// [AuthException] with a provider-independent code for state and localization.
abstract interface class AuthRepository {
  /// Emits the restored session first, followed by sign-in and sign-out changes.
  /// A successful result with null data means signed out.
  /// Authentication failures are emitted as [AuthException] stream errors.
  /// Stream setup failures can throw synchronously and must also be handled.
  Stream<DataResult<AuthSession>> authStateChanges();

  /// Creates an email/password account, saves its name and returns its session.
  /// Throws [AuthException] on authentication failure.
  /// A profile-update failure leaves the created account available for sign-in.
  /// Staff provisioning belongs to a separate administrative flow.
  Future<DataResult<AuthSession>> signUp(AuthRegistration registration);

  /// Signs in with email/password and returns the authenticated session.
  /// Throws [AuthException] on authentication failure.
  Future<DataResult<AuthSession>> signIn(AuthCredentials credentials);

  /// Signs out the current user and returns a successful result.
  /// Throws [AuthException] if sign-out fails.
  Future<Result> signOut();

  /// Requests a reset email and returns a successful result.
  /// Success acknowledges the request; it does not confirm account existence.
  /// Throws [AuthException] if the request fails.
  Future<Result> sendPasswordResetEmail(String email);
}
