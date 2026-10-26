/// A display option for [AppSelectField].
final class AppSelectOption<T> {
  /// Creates an option from a typed value and its visible label.
  const AppSelectOption({required this.value, required this.label});

  /// Value passed to the selection callback.
  final T value;

  /// Visible option text.
  final String label;
}
