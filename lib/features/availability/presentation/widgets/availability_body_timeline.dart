part of 'availability_body.dart';

/// Shared tick header and Monday-to-Sunday tracks.
final class _AvailabilityTimeline extends StatelessWidget {
  const _AvailabilityTimeline();

  @override
  Widget build(BuildContext context) {
    final branch = context.watch<AvailabilityBranchCubit>().state;
    if (branch is WatchLoaded<Branch, InstitutionErrorCode>) {
      final timeline = AvailabilityTimeline(branch.data.workingHours);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s4,
        children: [
          _AvailabilityTimelineTicks(timeline: timeline),
          for (final day in Weekday.values)
            _AvailabilityTimelineRow(day: day, timeline: timeline),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
