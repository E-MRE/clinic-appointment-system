import 'dart:async';

import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/app_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Observes persisted sessions and later auth changes through the domain contract.
/// The caller owns this cubit and must close it to release the subscription.
final class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthInitial()) {
    _observeSession();
  }

  final AuthRepository _repository;
  StreamSubscription<DataResult<AuthSession>>? _subscription;
  bool _isRetrying = false;
  bool _isClosing = false;

  bool get _isClosingOrClosed => _isClosing || isClosed;
  bool get _shouldIgnoreRetry => _isRetrying || _isClosingOrClosed;

  /// Restarts session observation after a failure, cancelling the old listener.
  /// Repeated requests during retry or after disposal are ignored.
  Future<void> retry() async {
    if (_shouldIgnoreRetry) return;
    _isRetrying = true;
    try {
      await _cancelSessionSubscription();
      if (_isClosingOrClosed) return;
      _observeSession();
    } on Exception catch (error, stackTrace) {
      _onError(error, stackTrace);
    } finally {
      _isRetrying = false;
    }
  }

  Future<void> _cancelSessionSubscription() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  void _observeSession() {
    emit(const AuthLoading());
    try {
      _subscription = _repository.authStateChanges().listen(
        _onSessionChanged,
        onError: _onError,
      );
    } on Exception catch (error, stackTrace) {
      _onError(error, stackTrace);
    }
  }

  void _onSessionChanged(DataResult<AuthSession> result) {
    if (_isClosingOrClosed) return;
    if (result.isNotSuccess) {
      emit(const AuthFailure(AuthErrorCode.unexpected));
      return;
    }
    final session = result.data;
    emit(session == null ? const AuthSignedOut() : AuthSignedIn(session));
  }

  void _onError(Object error, StackTrace stackTrace) {
    if (_isClosingOrClosed) return;
    final code = error is AuthException ? error.code : AuthErrorCode.unexpected;
    emit(AuthFailure(code));
  }

  /// Cancels session observation before closing the state stream.
  @override
  Future<void> close() async {
    _isClosing = true;
    await _cancelSessionSubscription();
    await super.close();
  }
}
