import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';

/// One controllable broadcast stream per key, recording each request.
final class KeyedStreams<T> {
  final Map<String, StreamController<DataResult<List<T>>>> _controllers = {};

  /// Keys in the order they were requested.
  final List<String> requested = [];

  StreamController<DataResult<List<T>>> _controller(String key) {
    return _controllers.putIfAbsent(key, StreamController.broadcast);
  }

  /// Returns the stream for [key] and records the request.
  Stream<DataResult<List<T>>> watch(String key) {
    requested.add(key);
    return _controller(key).stream;
  }

  /// Emits a successful list on [key].
  void emit(String key, List<T> items) {
    _controller(key).add(DataResult.success(data: items));
  }

  /// Emits a failed result on [key].
  void emitFailure(String key) =>
      _controller(key).add(const DataResult.error());

  /// Emits a stream error on [key].
  void emitError(String key) => _controller(key).addError(Exception('stream'));

  /// Whether [key] currently has a subscriber.
  bool isWatched(String key) => _controller(key).hasListener;

  /// Closes every controller.
  Future<void> close() async {
    for (final controller in _controllers.values) {
      await controller.close();
    }
  }
}
