/// Base exception for application-specific errors.
class AppException implements Exception {
  const AppException({this.message = ''});

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class ValidationException extends AppException {
  const ValidationException({required this.field, super.message});

  final String field;
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({super.message});
}

class NotFoundException extends AppException {
  const NotFoundException({super.message});
}

class ConflictException extends AppException {
  const ConflictException({super.message});
}

class UnexpectedException extends AppException {
  const UnexpectedException({super.message});
}
