import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';

/// Observes one list stream per key and reports their concatenation once
/// every key has delivered a successful list.
/// Failed results, stream errors and synchronous setup errors all report
/// [onFailure]; cancelled subscriptions never report again.
final class KeyedListWatch<K, T> {
  /// Creates an idle watch reporting through the supplied callbacks.
  KeyedListWatch({required this.onChanged, required this.onFailure});

  /// Receives the merged lists in key order.
  final void Function(List<T> items) onChanged;

  /// Called once for any failure of a watched stream.
  final void Function() onFailure;

  final Map<K, StreamSubscription<DataResult<List<T>>>> _subscriptions = {};
  final Map<K, List<T>> _latest = {};
  List<K> _keys = const [];

  /// Replaces every subscription with one stream per key from [open].
  /// An empty key list reports an empty result at once.
  void watch(List<K> keys, Stream<DataResult<List<T>>> Function(K key) open) {
    cancel();
    _keys = List<K>.unmodifiable(keys);
    if (_keys.isEmpty) {
      onChanged(const []);
      return;
    }
    for (final key in _keys) {
      try {
        _subscriptions[key] = open(key).listen(
          (DataResult<List<T>> result) => _onResult(key, result),
          onError: (Object _) => onFailure(),
        );
      } on Exception {
        cancel();
        onFailure();
        return;
      }
    }
  }

  /// Cancels every subscription and forgets the delivered lists.
  void cancel() {
    for (final subscription in _subscriptions.values) {
      unawaited(subscription.cancel());
    }
    _subscriptions.clear();
    _latest.clear();
    _keys = const [];
  }

  void _onResult(K key, DataResult<List<T>> result) {
    final items = result.data;
    if (result.isNotSuccess || items == null) {
      onFailure();
      return;
    }
    _latest[key] = items;
    if (_latest.length < _keys.length) return;
    onChanged([for (final watchedKey in _keys) ...?_latest[watchedKey]]);
  }
}
