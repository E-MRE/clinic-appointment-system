part of 'app_filter_chips.dart';

/// Horizontally scrollable filter chips that toggle independent choices.
final class AppMultiFilterChips<T> extends StatelessWidget {
  /// Creates multi-select chips for the supplied choices.
  const AppMultiFilterChips({
    required this.choices,
    required this.selected,
    required this.onSelectionChanged,
    super.key,
  });

  /// Choices in display order.
  final List<AppChoice<T>> choices;

  /// Currently selected values.
  final Set<T> selected;

  /// Called with the immutable selection after one value is toggled.
  final ValueChanged<Set<T>> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: AppSizes.s8,
        children: [
          for (final choice in choices)
            _FilterChip<T>(
              choice: choice,
              selected: selected.contains(choice.value),
              onSelected: _toggle,
            ),
        ],
      ),
    );
  }

  void _toggle(T value) {
    final next = Set<T>.of(selected);
    if (!next.add(value)) next.remove(value);
    onSelectionChanged(Set<T>.unmodifiable(next));
  }
}
