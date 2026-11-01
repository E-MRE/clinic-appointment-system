part of 'availability_body.dart';

/// Themed range bar with accessible out-of-hours warnings and a pending outline.
final class _AvailabilityTimelineBar extends StatelessWidget {
  const _AvailabilityTimelineBar({required this.window, required this.variant});
  final AvailabilityWindow window;
  final AvailabilityTimelineBarVariant variant;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: variant == AvailabilityTimelineBarVariant.flagged
          ? LocaleKeys.availability_flaggedRange.translate(
              args: [window.range.label],
            )
          : window.range.label,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: variant.background(context.colorScheme),
          borderRadius: const AppRadius.small(),
        ),
        child: _AvailabilityTimelineBarOutline(
          variant: variant,
          child: Center(
            child: AppText.caption(
              window.range.label,
              tone: variant.tone,
              maxLines: _labelLines,
              overflow: TextOverflow.clip,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  /// Keeps range text on a single timeline line.
  int get _labelLines => 1;
}
