import 'package:clinic_appointment_system/core/errors/result.dart';

/// The outcome of an operation that returns typed data on success.
final class DataResult<T> extends Result {
  /// Creates a successful result with the given data.
  const DataResult.success({required this.data, super.message})
    : errorCode = null,
      super.success();

  /// Creates an error result with the given data and an optional error code.
  const DataResult.error({this.data, this.errorCode, super.message = ''})
    : super.error();

  /// The data returned by the operation, if any.
  final T? data;

  /// The feature error code of a failed operation, if any. Screens turn it
  /// into a message through the code's extension.
  final Enum? errorCode;
}
