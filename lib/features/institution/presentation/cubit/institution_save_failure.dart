part of 'institution_save_state.dart';

/// A save request failed with a domain [code].
final class InstitutionSaveFailure<T> extends InstitutionSaveState<T> {
  /// Creates a failure state identified by [code].
  const InstitutionSaveFailure(this.code);

  /// The reason to localize at the presentation boundary.
  final InstitutionErrorCode code;
}
