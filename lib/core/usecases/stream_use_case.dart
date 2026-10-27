/// An application operation that observes changes over time.
/// Implementations receive their repositories through the constructor, keep
/// no state and provide [call].
abstract interface class StreamUseCase<Output, Params> {
  /// Starts observing with [params].
  Stream<Output> call(Params params);
}
