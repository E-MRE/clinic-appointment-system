part of 'app_choice_controls.dart';

/// Horizontally scrollable single-select filter chips.
final class AppFilterChips<T> extends StatelessWidget {
  /// Creates filter chips for the supplied choices.
  const AppFilterChips({
    required this.choices,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Choices in display order.
  final List<AppChoice<T>> choices;

  /// Currently selected value.
  final T selected;

  /// Called with the newly selected value.
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final choice in choices) ...[
            _FilterChip<T>(
              choice: choice,
              selected: choice.value == selected,
              onSelected: onSelected,
            ),
            const EmptySize.s8Width(),
          ],
        ],
      ),
    );
  }
}
