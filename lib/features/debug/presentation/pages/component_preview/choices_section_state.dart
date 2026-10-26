part of 'component_preview_page.dart';

/// Keeps the two example selections independent.
final class _ChoicesSectionState extends State<_ChoicesSection> {
  _PreviewTheme _filter = _PreviewTheme.light;
  _PreviewTheme _segment = _PreviewTheme.light;

  @override
  Widget build(BuildContext context) {
    final choices = [
      for (final theme in _PreviewTheme.values)
        AppChoice(value: theme, label: theme.label.translate()),
    ];
    return Column(
      spacing: AppSizes.s16,
      children: [
        AppFilterChips(
          choices: choices,
          selected: _filter,
          onSelected: (value) {
            setState(() {
              _filter = value;
            });
          },
        ),
        AppSegmentedControl(
          choices: choices,
          selected: _segment,
          onSelected: (value) {
            setState(() {
              _segment = value;
            });
          },
        ),
      ],
    );
  }
}
