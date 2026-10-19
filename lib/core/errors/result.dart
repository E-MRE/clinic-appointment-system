import 'package:clinic_appointment_system/core/errors/failure.dart';

/// A typed outcome; nullable successful values are supported.
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

final class Failed<T> extends Result<T> {
  const Failed(this.failure);
  final Failure failure;
}
