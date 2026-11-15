part of 'availability_body.dart';

/// Layers branch openings, persisted windows and a valid desktop draft.
final class _AvailabilityTimelineTrack extends StatelessWidget {
  const _AvailabilityTimelineTrack({required this.day, required this.timeline});
  final Weekday day;
  final AvailabilityTimeline timeline;

  @override
  Widget build(BuildContext context) {
    final branch = context.watch<AvailabilityBranchCubit>().state;
    final availability = context.watch<StaffAvailabilityCubit>().state;
    final pending = context
        .watch<AvailabilityWindowDraftCubit>()
        .state
        .validWindow;
    if (branch is WatchLoaded<Branch, InstitutionErrorCode>) {
      if (availability
          is WatchLoaded<StaffAvailability, AvailabilityErrorCode>) {
        return _buildLoadedTrack(
          branch: branch.data,
          availability: availability.data,
          pending: pending,
        );
      }
    }
    return const SizedBox.shrink();
  }

  /// Builds the track layers after both loaded states are available.
  Widget _buildLoadedTrack({
    required Branch branch,
    required StaffAvailability availability,
    required AvailabilityWindow? pending,
  }) {
    return SizedBox(
      height: AppSizes.s40,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned.fill(child: _AvailabilityTimelineBackground(day: day)),
              for (final range in branch.workingHours.rangesOn(day))
                _buildOpening(
                  context,
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
                  pending != null &&
                  pending.fallsOnWeekday(day))
                _buildPositionedBar(
                  window: pending,
                  segment: timeline.segmentOf(pending.range),
                  trackWidth: constraints.maxWidth,
                  variant: AvailabilityTimelineBarVariant.pending,
                ),
            ],
          );
        },
      ),
    );
  }

  /// Builds a branch opening with colors selected from the active theme.
  Widget _buildOpening(
    BuildContext context, {
    required TimelineSegment segment,
    required double trackWidth,
  }) {
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
