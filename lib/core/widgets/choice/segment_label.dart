part of 'app_segmented_control.dart';

/// Label inside a segmented control segment.
final class _SegmentLabel extends StatelessWidget {
  const _SegmentLabel({required this.label, required this.style});

  final String label;
  final _SegmentStyle style;

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
