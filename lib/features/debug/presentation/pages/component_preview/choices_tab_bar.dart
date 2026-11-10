part of 'component_preview_page.dart';

/// Underlined tab bar sample for choice preview.
final class _ChoicesTabBar extends StatelessWidget {
  const _ChoicesTabBar({required this.selected, required this.onSelected});

  final _PreviewTheme selected;
  final ValueChanged<_PreviewTheme> onSelected;

  @override
  Widget build(BuildContext context) {
    return AppTabBar<_PreviewTheme>(
      choices: [
        for (final theme in _PreviewTheme.values)
          AppChoice(value: theme, label: theme.label.translate()),
      ],
      selected: selected,
      onSelected: onSelected,
    );
  }
}
