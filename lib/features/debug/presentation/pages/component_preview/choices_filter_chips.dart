part of 'component_preview_page.dart';

/// Filter chips sample for choice preview.
final class _ChoicesFilterChips extends StatelessWidget {
  const _ChoicesFilterChips({required this.selected, required this.onSelected});

  final _PreviewTheme selected;
  final ValueChanged<_PreviewTheme> onSelected;

  @override
  Widget build(BuildContext context) {
    return AppFilterChips(
      choices: [
        for (final theme in _PreviewTheme.values)
          AppChoice(value: theme, label: theme.label.translate()),
      ],
      selected: selected,
      onSelected: onSelected,
    );
  }
}
