part of 'availability_body.dart';

/// Adds the dashed border only to pending bars, leaving saved fills intact.
final class _AvailabilityTimelineBarOutline extends StatelessWidget {
  const _AvailabilityTimelineBarOutline({
    required this.variant,
    required this.child,
  });
  final AvailabilityTimelineBarVariant variant;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (variant.border(context.colorScheme) case final border?) {
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
