part of 'app_filter_chips.dart';

/// Label inside a selectable filter chip.
final class _FilterChipLabel extends StatelessWidget {
  const _FilterChipLabel({required this.label, required this.style});

  final String label;
  final _FilterChipStyle style;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppSizes.s32),
      child: Padding(
        padding: const AppPadding.chip(),
        child: Center(
          child: AppText.label(
            label,
            tone: style.tone,
            fontWeight: style.weight,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
