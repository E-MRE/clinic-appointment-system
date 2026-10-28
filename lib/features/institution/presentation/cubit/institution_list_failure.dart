part of 'institution_list_state.dart';

/// The stream failed with a domain [code].
final class InstitutionListFailure<T> extends InstitutionListState<T> {
  /// Creates a failure state identified by [code].
  const InstitutionListFailure(this.code);

  /// The failure reason to localize at the presentation boundary.
  final InstitutionErrorCode code;
}
