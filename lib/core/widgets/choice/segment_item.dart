part of 'app_choice_controls.dart';

/// One selectable segment.
final class _Segment<T> extends StatelessWidget {
  const _Segment({
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
      style: _ChoiceStyle.segment,
    );
  }
}
