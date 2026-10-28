part of 'institution_save_state.dart';

/// A save request completed with [value].
final class InstitutionSaveSaved<T> extends InstitutionSaveState<T> {
  /// Creates a saved state containing the persisted [value].
  const InstitutionSaveSaved(this.value);

  /// The entity returned by the use case.
  final T value;
}
