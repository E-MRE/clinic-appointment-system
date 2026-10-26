part of 'app_choice_controls.dart';

/// Shared material, tap target, padding and label for choice variants.
final class _ChoiceItem<T> extends StatelessWidget {
  const _ChoiceItem({
    required this.choice,
    required this.selected,
    required this.onSelected,
    required this.style,
  });

  final AppChoice<T> choice;
  final bool selected;
  final ValueChanged<T> onSelected;
  final _ChoiceStyle style;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: style.background(context.colorScheme, selected),
      borderRadius: style.radius,
      child: InkWell(
        onTap: () {
          onSelected(choice.value);
        },
        borderRadius: style.radius,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSizes.s32),
          child: Padding(
            padding: const AppPadding.chip(),
            child: Center(
              child: AppText.label(
                choice.label,
                tone: style.tone(selected),
                fontWeight: style.weight(selected),
                maxLines: style.maxLines,
                overflow: style.overflow,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
