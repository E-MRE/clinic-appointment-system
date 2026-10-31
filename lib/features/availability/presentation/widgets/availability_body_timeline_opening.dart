part of 'availability_body.dart';

/// Light branch-open segment positioned entirely from normalized geometry.
final class _AvailabilityTimelineOpening extends StatelessWidget {
  const _AvailabilityTimelineOpening({
    required this.segment,
    required this.trackWidth,
  });
  final TimelineSegment segment;
  final double trackWidth;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: segment.start * trackWidth,
      width: segment.width * trackWidth,
      top: AppSizes.borderThin,
      bottom: AppSizes.borderThin,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.screenSize.isDesktop
              ? context.colorScheme.surface
              : context.colorScheme.surfaceContainerLow,
          borderRadius: const AppRadius.small(),
        ),
      ),
    );
  }
}
