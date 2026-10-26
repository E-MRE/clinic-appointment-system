/// A label and typed value used by single selection controls.
final class AppChoice<T> {
  /// Creates a visible choice with its associated value.
  const AppChoice({required this.value, required this.label});

  /// Selected value represented by this choice.
  final T value;

  /// Visible choice label.
  final String label;
}
