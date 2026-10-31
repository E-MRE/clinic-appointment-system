import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';

/// Retains callbacks to simulate events already queued when cancellation starts.
final class LateWatchStream extends Stream<DataResult<String>> {
  LateWatchStream({Future<void> Function()? onCancel}) {
    _controller = StreamController<DataResult<String>>(
      onCancel: () async {
        cancelled = true;
        await onCancel?.call();
      },
    );
  }

  late final StreamController<DataResult<String>> _controller;
  void Function(DataResult<String>)? _onData;
  bool cancelled = false;

  void deliver(String value) => _onData?.call(DataResult.success(data: value));

  Future<void> close() => _controller.close();

  @override
  StreamSubscription<DataResult<String>> listen(
    void Function(DataResult<String>)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    _onData = onData;
    return _controller.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}
