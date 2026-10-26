part of 'app_segmented_control.dart';

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
    final style = _SegmentStyle.fromSelected(selected);
    return Material(
      color: style.background(context.colorScheme),
      borderRadius: const AppRadius.full(),
      child: InkWell(
        onTap: () {
          onSelected(choice.value);
        },
        borderRadius: const AppRadius.full(),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSizes.s32),
          child: Padding(
            padding: const AppPadding.chip(),
            child: Center(
              child: AppText.label(
                choice.label,
                tone: style.tone,
                fontWeight: style.weight,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
