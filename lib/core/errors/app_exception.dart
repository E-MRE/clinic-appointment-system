/// Base exception for application-specific errors.
class AppException implements Exception {
  const AppException({this.message = ''});

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// An exception that is thrown when a validation error occurs.
final class ValidationException extends AppException {
  const ValidationException({required this.field, super.message});

  final String field;
}

/// An exception that is thrown when the user is not authorized to perform an action.
final class UnauthorizedException extends AppException {
  const UnauthorizedException({super.message});
}

/// An exception that is thrown when a resource is not found.
final class NotFoundException extends AppException {
  const NotFoundException({super.message});
}

/// An exception that is thrown when a conflict occurs.
final class ConflictException extends AppException {
  const ConflictException({super.message});
}

/// An exception that is thrown when an unexpected error occurs.
final class UnexpectedException extends AppException {
  const UnexpectedException({super.message});
}
