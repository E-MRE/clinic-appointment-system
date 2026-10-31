part of 'availability_body.dart';

/// Places a range on the track using only the model's start and width.
final class _AvailabilityTimelinePositionedBar extends StatelessWidget {
  const _AvailabilityTimelinePositionedBar({
    required this.window,
    required this.segment,
    required this.trackWidth,
    required this.variant,
  });
  final AvailabilityWindow window;
  final TimelineSegment segment;
  final double trackWidth;
  final AvailabilityTimelineBarVariant variant;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: segment.start * trackWidth,
      width: segment.width * trackWidth,
      top: AppSizes.s4,
      height: AppSizes.availabilityTimelineBar,
      child: _AvailabilityTimelineBar(window: window, variant: variant),
    );
  }
}
