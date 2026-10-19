/// Expected domain failures. Translate these into messages in presentation.
sealed class Failure {
  const Failure();
}

final class ValidationFailure extends Failure {
  const ValidationFailure({required this.field});
  final String field;
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure();
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure();
}

final class ConflictFailure extends Failure {
  const ConflictFailure();
}

/// Log technical details in the data layer; never expose raw exceptions to UI.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure();
}
