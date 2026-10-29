part of 'app_filter_chips.dart';

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
    final style = _FilterChipStyle.fromSelected(selected);
    return Material(
      color: style.background(context.colorScheme),
      borderRadius: const AppRadius.small(),
      child: InkWell(
        onTap: () {
          onSelected(choice.value);
        },
        borderRadius: const AppRadius.small(),
        child: _FilterChipLabel(label: choice.label, style: style),
      ),
    );
  }
}
