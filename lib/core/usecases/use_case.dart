/// One application operation the presentation layer can run.
/// Implementations receive their repositories through the constructor, keep
/// no state and provide [call].
abstract interface class UseCase<Output, Params> {
  /// Runs the operation with [params].
  Future<Output> call(Params params);
}
