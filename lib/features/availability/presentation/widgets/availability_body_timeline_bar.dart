part of 'availability_body.dart';

/// Themed range bar with accessible out-of-hours warnings and a pending outline.
final class _AvailabilityTimelineBar extends StatelessWidget {
  const _AvailabilityTimelineBar({required this.window, required this.variant});
  final AvailabilityWindow window;
  final AvailabilityTimelineBarVariant variant;

  /// Keeps range text on a single timeline line.
  int get _labelLines => 1;

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
        child: _buildOutline(
          context,
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

  /// Adds the pending outline when this range needs one.
  Widget _buildOutline(BuildContext context, {required Widget child}) {
    final border = variant.border(context.colorScheme);
    if (border != null) {
      return AppDashedBorder(
        color: border.color,
        strokeWidth: border.width,
        radius: const AppRadius.small(),
        child: child,
      );
    }
    return child;
  }
}
