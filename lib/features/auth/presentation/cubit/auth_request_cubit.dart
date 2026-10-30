import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/auth_exception.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A template for request progress and failure handling.
/// Concrete cubits supply the use case operation; use cases validate input.
abstract class AuthRequestCubit extends Cubit<AuthRequestState> {
  AuthRequestCubit() : super(const AuthRequestInitial());

  bool get _shouldIgnoreRequest => isClosed || state is AuthRequestLoading;

  /// Runs one request at a time and ignores completions after close.
  @protected
  Future<void> executeRequest(Future<Result> Function() request) async {
    if (_shouldIgnoreRequest) return;
    try {
      emit(const AuthRequestLoading());
      final result = await request();
      if (isClosed) return;
      if (result.isNotSuccess) {
        _emitMessageFailure(result.message);
        return;
      }
      emit(const AuthRequestSuccess());
    } on AuthException catch (error) {
      _emitFailure(AuthRequestFailure.code(error.code));
    } on Exception {
      _emitFailure(const AuthRequestFailure.code(AuthErrorCode.unexpected));
    }
  }

  void _emitMessageFailure(String message) => _emitFailure(
    message.isEmpty
        ? const AuthRequestFailure.code(AuthErrorCode.unexpected)
        : AuthRequestFailure.message(message),
  );

  void _emitFailure(AuthRequestFailure failure) {
    if (isClosed) return;
    emit(failure);
  }
}
