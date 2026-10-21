import 'dart:async';

import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/app_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/domain/mappers/auth_exception_mapper.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Adapts Firebase Auth to the domain contract using constructor injection.
final class FirebaseAuthRepository implements AuthRepository {
  const FirebaseAuthRepository(this._auth, this._exceptionMapper);

  final FirebaseAuth _auth;
  final AuthExceptionMapper _exceptionMapper;

  @override
  Stream<DataResult<AuthSession>> authStateChanges() {
    try {
      return _auth
          .authStateChanges()
          .map(
            (user) => DataResult<AuthSession>.success(
              data: user == null ? null : _sessionFromUser(user),
            ),
          )
          .transform(
            StreamTransformer<
              DataResult<AuthSession>,
              DataResult<AuthSession>
            >.fromHandlers(handleError: _handleAuthStateError),
          );
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(_exceptionMapper.map(error), stackTrace);
    }
  }

  void _handleAuthStateError(
    Object error,
    StackTrace stackTrace,
    EventSink<DataResult<AuthSession>> sink,
  ) {
    sink.addError(_exceptionMapper.map(error), stackTrace);
  }

  @override
  Future<DataResult<AuthSession>> signUp(AuthCredentials credentials) =>
      _execute(() async {
        final result = await _auth.createUserWithEmailAndPassword(
          email: credentials.email.trim(),
          password: credentials.password,
        );
        return _sessionFromCredential(result);
      });

  @override
  Future<DataResult<AuthSession>> signIn(AuthCredentials credentials) =>
      _execute(() async {
        final result = await _auth.signInWithEmailAndPassword(
          email: credentials.email.trim(),
          password: credentials.password,
        );
        return _sessionFromCredential(result);
      });

  @override
  Future<Result> signOut() => _executeAction(_auth.signOut);

  @override
  Future<Result> sendPasswordResetEmail(String email) =>
      _executeAction(() => _auth.sendPasswordResetEmail(email: email.trim()));

  AuthSession _sessionFromCredential(UserCredential credential) {
    final user = credential.user;
    if (user == null) throw const AuthException(AuthErrorCode.unexpected);
    return _sessionFromUser(user);
  }

  AuthSession _sessionFromUser(User user) {
    final email = user.email;
    if (email == null || email.trim().isEmpty) {
      throw const AuthException(AuthErrorCode.unexpected);
    }
    return AuthSession(
      userId: user.uid,
      email: email,
      isEmailVerified: user.emailVerified,
    );
  }

  Future<DataResult<T>> _execute<T>(Future<T> Function() operation) async {
    try {
      return DataResult.success(data: await operation());
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(_exceptionMapper.map(error), stackTrace);
    }
  }

  Future<Result> _executeAction(Future<void> Function() operation) async {
    try {
      await operation();
      return const Result.success();
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(_exceptionMapper.map(error), stackTrace);
    }
  }
}
