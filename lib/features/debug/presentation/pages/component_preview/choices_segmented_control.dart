part of 'component_preview_page.dart';

/// Segmented control sample for choice preview.
final class _ChoicesSegmentedControl extends StatelessWidget {
  const _ChoicesSegmentedControl({
    required this.selected,
    required this.onSelected,
  });

  final _PreviewTheme selected;
  final ValueChanged<_PreviewTheme> onSelected;

  @override
  Widget build(BuildContext context) {
    return AppSegmentedControl(
      choices: [
        for (final theme in _PreviewTheme.values)
          AppChoice(value: theme, label: theme.label.translate()),
      ],
      selected: selected,
      onSelected: onSelected,
    );
  }
}
