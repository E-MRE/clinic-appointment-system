import 'package:clinic_appointment_system/core/errors/failure.dart';

/// The outcome of an operation that does not return data.
sealed class Result {
  const Result._success() : isSuccess = true, failure = null;
  const Result._error(this.failure) : isSuccess = false;

  const factory Result.success() = _OperationResult.success;
  const factory Result.error({required Failure failure}) =
      _OperationResult.error;

  final bool isSuccess;
  final Failure? failure;
}

final class _OperationResult extends Result {
  const _OperationResult.success() : super._success();
  const _OperationResult.error({required Failure failure})
    : super._error(failure);
}

/// The outcome of an operation that returns typed data on success.
final class DataResult<T> extends Result {
  const DataResult.success({required this.data}) : super._success();
  const DataResult.error({required Failure failure})
    : data = null,
      super._error(failure);

  final T? data;
}
