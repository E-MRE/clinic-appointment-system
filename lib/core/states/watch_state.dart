import 'package:equatable/equatable.dart';

/// The closed set of observation states, with typed data and failure codes.
/// Variants must expose the values defining their state identity.
sealed class WatchState<T, E> extends Equatable {
  /// Creates an observation state.
  const WatchState();
}

/// The observation is waiting for a result.
final class WatchLoading<T, E> extends WatchState<T, E> {
  /// Creates the loading state.
  const WatchLoading();

  /// Loading has no associated values.
  @override
  List<Object?> get props => [];
}

/// The observation has received successful data.
final class WatchLoaded<T, E> extends WatchState<T, E> {
  /// Creates the loaded state containing [data].
  const WatchLoaded(this.data);

  /// The latest observed data.
  final T data;

  /// The observed data defining value identity.
  @override
  List<Object?> get props => [data];
}

/// The observation failed with a domain code.
final class WatchFailure<T, E> extends WatchState<T, E> {
  /// Creates the failure state identified by [code].
  const WatchFailure(this.code);

  /// The reason to localize at the presentation boundary.
  final E code;

  /// The failure code defining value identity.
  @override
  List<Object?> get props => [code];
}
