import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/core/usecases/stream_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shares stream subscription, retry and close-race handling for institution lists.
/// Subclasses supply the typed watch use case and expose the parameters their
/// screen needs to start or replace an observation.
abstract class InstitutionListCubit<
  T,
  Params,
  UseCaseType extends StreamUseCase<DataResult<List<T>>, Params>
>
    extends Cubit<InstitutionListState<T>> {
  /// Creates a list observer for a [watchUseCase].
  InstitutionListCubit(UseCaseType watchUseCase)
    : _watchUseCase = watchUseCase,
      super(InstitutionListLoading<T>());

  final UseCaseType _watchUseCase;
  StreamSubscription<DataResult<List<T>>>? _subscription;
  Future<void> Function()? _retryAction;
  int _watchGeneration = 0;
  bool _isClosing = false;

  bool get _isClosingOrClosed => _isClosing || isClosed;

  /// Cancels the current list stream and begins observing with [params].
  /// Events from an earlier observation are ignored as soon as this is called.
  @protected
  Future<void> watchWith(Params params) async {
    if (_isClosingOrClosed) return;
    final generation = ++_watchGeneration;
    _retryAction = () => watchWith(params);
    emit(InstitutionListLoading<T>());
    if (_subscription != null) await _cancelSubscription();
    if (_isClosingOrClosed || generation != _watchGeneration) return;
    try {
      // Explicit `call`: the web dev compiler cannot invoke a callable object
      // typed by a type parameter.
      _subscription = _watchUseCase.call(params).listen(
        (result) => _onResult(result, generation),
        onError: (Object error, StackTrace stackTrace) {
          _onError(error, generation);
        },
      );
    } on Exception catch (error) {
      _emitFailure(_errorCode(error), generation);
    }
  }

  /// Restarts the last observation after cancelling its current subscription.
  /// Does nothing before the first watch or while the cubit is closing.
  Future<void> retry() async {
    if (_isClosingOrClosed) return;
    await _retryAction?.call();
  }

  /// Discards the current selection and all results from its old stream.
  Future<void> clear() async {
    if (_isClosingOrClosed) return;
    _watchGeneration++;
    _retryAction = null;
    emit(InstitutionListLoading<T>());
    await _cancelSubscription();
  }

  void _onResult(DataResult<List<T>> result, int generation) {
    if (_isClosingOrClosed || generation != _watchGeneration) return;
    final items = result.data;
    if (result.isNotSuccess || items == null) {
      _emitFailure(InstitutionErrorCode.unavailable, generation);
      return;
    }
    emit(InstitutionListLoaded(List<T>.unmodifiable(items)));
  }

  void _onError(Object error, int generation) {
    _emitFailure(_errorCode(error), generation);
  }

  void _emitFailure(InstitutionErrorCode code, int generation) {
    if (_isClosingOrClosed || generation != _watchGeneration) return;
    emit(InstitutionListFailure<T>(code));
  }

  InstitutionErrorCode _errorCode(Object error) => error is InstitutionException
      ? error.code
      : InstitutionErrorCode.unavailable;

  Future<void> _cancelSubscription() async {
    final subscription = _subscription;
    _subscription = null;
    await subscription?.cancel();
  }

  /// Cancels the active stream and ignores any pending callbacks before closing.
  @override
  Future<void> close() async {
    _isClosing = true;
    _watchGeneration++;
    await _cancelSubscription();
    await super.close();
  }
}
