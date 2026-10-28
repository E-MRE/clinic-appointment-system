part of 'institution_list_state.dart';

/// The observed list contains [items].
final class InstitutionListLoaded<T> extends InstitutionListState<T> {
  /// Creates a loaded state with the current [items].
  const InstitutionListLoaded(this.items);

  /// The current records from the stream.
  final List<T> items;
}
