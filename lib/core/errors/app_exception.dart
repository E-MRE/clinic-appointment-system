/// Base exception for application-specific errors.
class AppException implements Exception {
  const AppException({this.message = ''});

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}
