import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_save_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shares progress, failure mapping and single-flight behavior for save requests.
/// Subclasses provide their create and update use cases and call
/// [executeRequest] for each operation.
abstract class InstitutionSaveCubit<T> extends Cubit<InstitutionSaveState<T>> {
  /// Creates a save cubit in the initial state.
  InstitutionSaveCubit() : super(InstitutionSaveInitial<T>());

  bool _isRequestInFlight = false;
  bool _isClosing = false;

  bool get _isClosingOrClosed => _isClosing || isClosed;

  /// Runs [request] once, maps domain failures to codes and ignores late results.
  @protected
  Future<void> executeRequest(Future<DataResult<T>> Function() request) async {
    if (_isClosingOrClosed || _isRequestInFlight) return;
    _isRequestInFlight = true;
    emit(InstitutionSaveSaving<T>());
    try {
      final result = await request();
      if (_isClosingOrClosed) return;
      final value = result.data;
      if (result.isNotSuccess || value == null) {
        emit(InstitutionSaveFailure<T>(InstitutionErrorCode.unavailable));
        return;
      }
      emit(InstitutionSaveSaved<T>(value));
    } on InstitutionException catch (error) {
      _emitFailure(error.code);
    } on Exception {
      _emitFailure(InstitutionErrorCode.unavailable);
    } finally {
      _isRequestInFlight = false;
    }
  }

  void _emitFailure(InstitutionErrorCode code) {
    if (_isClosingOrClosed) return;
    emit(InstitutionSaveFailure<T>(code));
  }

  /// Closes the cubit and makes any pending request completion a no-op.
  @override
  Future<void> close() async {
    _isClosing = true;
    await super.close();
  }
}
