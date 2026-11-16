part of 'availability_body.dart';

/// Shows branch openings and saved or pending availability on one timeline.
final class _AvailabilityTimelineLoadedTrack extends StatelessWidget {
  const _AvailabilityTimelineLoadedTrack({
    required this.day,
    required this.timeline,
    required this.branch,
    required this.availability,
    required this.pending,
  });

  final Weekday day;
  final AvailabilityTimeline timeline;
  final Branch branch;
  final StaffAvailability availability;
  final AvailabilityWindow? pending;

  @override
  Widget build(BuildContext context) {
    final pendingWindow = pending;
    return SizedBox(
      height: AppSizes.s40,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned.fill(child: _AvailabilityTimelineBackground(day: day)),
              for (final range in branch.workingHours.rangesOn(day))
                _AvailabilityTimelineOpening(
                  segment: timeline.segmentOf(range),
                  trackWidth: constraints.maxWidth,
                ),
              for (final window in availability.weeklyOn(day))
                _buildPositionedBar(
                  window: window,
                  segment: timeline.segmentOf(window.range),
                  trackWidth: constraints.maxWidth,
                  variant: window.fitsWithin(branch.workingHours)
                      ? AvailabilityTimelineBarVariant.saved
                      : AvailabilityTimelineBarVariant.flagged,
                ),
              if (context.screenSize.isDesktop &&
                  pendingWindow != null &&
                  pendingWindow.fallsOnWeekday(day))
                _buildPositionedBar(
                  window: pendingWindow,
                  segment: timeline.segmentOf(pendingWindow.range),
                  trackWidth: constraints.maxWidth,
                  variant: AvailabilityTimelineBarVariant.pending,
                ),
            ],
          );
        },
      ),
    );
  }

  /// Builds a saved, flagged or pending bar at its normalized track position.
  Widget _buildPositionedBar({
    required AvailabilityWindow window,
    required TimelineSegment segment,
    required double trackWidth,
    required AvailabilityTimelineBarVariant variant,
  }) {
    return Positioned(
      left: segment.start * trackWidth,
      width: segment.width * trackWidth,
      top: AppSizes.s4,
      height: AppSizes.availabilityTimelineBar,
      child: _AvailabilityTimelineBar(window: window, variant: variant),
    );
  }
}
