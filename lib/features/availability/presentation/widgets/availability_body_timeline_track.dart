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
    if (branch case WatchLoaded(data: final branch)) {
      if (availability case WatchLoaded(:final data)) {
        return SizedBox(
          height: AppSizes.s40,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: _AvailabilityTimelineBackground(day: day),
                  ),
                  for (final range in branch.workingHours.rangesOn(day))
                    _AvailabilityTimelineOpening(
                      segment: timeline.segmentOf(range),
                      trackWidth: constraints.maxWidth,
                    ),
                  for (final window in data.weeklyOn(day))
                    _AvailabilityTimelinePositionedBar(
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
                    _AvailabilityTimelinePositionedBar(
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
    }
    return const SizedBox.shrink();
  }
}
