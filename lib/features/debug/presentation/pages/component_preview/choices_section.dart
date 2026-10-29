part of 'component_preview_page.dart';

/// Displays interactive choice controls.
final class _ChoicesSection extends StatefulWidget {
  const _ChoicesSection();

  @override
  State<_ChoicesSection> createState() {
    return _ChoicesSectionState();
  }
}

/// Keeps the two example selections independent.
final class _ChoicesSectionState extends State<_ChoicesSection> {
  late _PreviewTheme _filter;
  late _PreviewTheme _segment;

  @override
  void initState() {
    super.initState();
    _filter = _PreviewTheme.light;
    _segment = _PreviewTheme.light;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSizes.s16,
      children: [
        _ChoicesFilterChips(
          selected: _filter,
          onSelected: (value) {
            setState(() {
              _filter = value;
            });
          },
        ),
        _ChoicesSegmentedControl(
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
