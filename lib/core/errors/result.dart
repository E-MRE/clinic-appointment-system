/// The outcome of an operation that does not return data.
class Result {
  /// Creates a successful result.
  const Result.success({this.message = ''}) : isSuccess = true;

  /// Creates an error result.
  const Result.error({this.message = ''}) : isSuccess = false;

  /// Whether the operation was successful.
  final bool isSuccess;

  /// Whether the operation was unsuccessful.
  bool get isNotSuccess => !isSuccess;

  /// A message describing the result of the operation.
  final String message;
}
