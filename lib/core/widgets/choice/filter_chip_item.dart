part of 'app_choice_controls.dart';

/// One selectable filter chip.
final class _FilterChip<T> extends StatelessWidget {
  const _FilterChip({
    required this.choice,
    required this.selected,
    required this.onSelected,
  });

  final AppChoice<T> choice;
  final bool selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return _ChoiceItem(
      choice: choice,
      selected: selected,
      onSelected: onSelected,
      style: _ChoiceStyle.chip,
    );
  }
}
