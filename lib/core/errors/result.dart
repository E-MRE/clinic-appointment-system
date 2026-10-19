import 'package:clinic_appointment_system/core/errors/failure.dart';

/// A typed outcome; nullable successful values are supported.
sealed class Result<T> {
  const Result();

  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) => switch (this) {
    Success<T>(:final value) => onSuccess(value),
    Failed<T>(:final failure) => onFailure(failure),
  };

  Result<R> map<R>(R Function(T value) transform) => switch (this) {
    Success<T>(:final value) => Success(transform(value)),
    Failed<T>(:final failure) => Failed(failure),
  };
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

final class Failed<T> extends Result<T> {
  const Failed(this.failure);
  final Failure failure;
}
