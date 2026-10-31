import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/stream_use_case.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shares stream subscription, retry and close-race handling.
/// Subclasses must supply state hooks and expose their typed watch parameters.
abstract class StreamWatchCubit<T, Params, S> extends Cubit<S> {
  /// Creates an observer using [watchUseCase] and [initialState].
  StreamWatchCubit(
    StreamUseCase<DataResult<T>, Params> watchUseCase,
    super.initialState,
  ) : _watchUseCase = watchUseCase;

  /// Subclasses must provide the waiting state for watch, retry and clear.
  @protected
  S loadingState();

  /// Subclasses must provide the state for successful, non-null [data].
  @protected
  S loadedState(T data);

  /// Subclasses must map [error] to a failure state.
  /// A failed result or missing data supplies null; other failures supply
  /// the synchronous exception or stream error unchanged.
  @protected
  S failureState(Object? error);

  final StreamUseCase<DataResult<T>, Params> _watchUseCase;
  StreamSubscription<DataResult<T>>? _subscription;
  Future<void> Function()? _retryAction;
  int _watchGeneration = _initialGeneration;
  bool _isClosing = false;

  static const int _initialGeneration = 0;

  bool get _isClosingOrClosed => _isClosing || isClosed;

  /// Cancels the current stream and begins observing with [params].
  /// Events from an earlier observation are ignored as soon as this is called.
  @protected
  Future<void> watchWith(Params params) async {
    if (_isClosingOrClosed) return;
    final generation = ++_watchGeneration;
    _retryAction = () => watchWith(params);
    emit(loadingState());
    if (_subscription != null) await _cancelSubscription();
    if (_isClosingOrClosed || generation != _watchGeneration) return;
    try {
      // Explicit `call`: the web dev compiler cannot invoke a callable object
      // typed by a type parameter.
      _subscription = _watchUseCase
          .call(params)
          .listen(
            (result) => _onResult(result, generation),
            onError: (Object error, StackTrace stackTrace) {
              _onError(error, generation);
            },
          );
    } on Exception catch (error) {
      _emitFailure(error, generation);
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
    emit(loadingState());
    await _cancelSubscription();
  }

  void _onResult(DataResult<T> result, int generation) {
    if (_isClosingOrClosed || generation != _watchGeneration) return;
    final items = result.data;
    if (result.isNotSuccess || items == null) {
      _emitFailure(null, generation);
      return;
    }
    emit(loadedState(items));
  }

  void _onError(Object error, int generation) {
    _emitFailure(error, generation);
  }

  void _emitFailure(Object? error, int generation) {
    if (_isClosingOrClosed || generation != _watchGeneration) return;
    emit(failureState(error));
  }

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
