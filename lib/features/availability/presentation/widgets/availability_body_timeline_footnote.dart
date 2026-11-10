part of 'availability_body.dart';

/// Explains the weekly axis, branch constraints and same-day conflict policy.
final class _AvailabilityTimelineFootnote extends StatelessWidget {
  const _AvailabilityTimelineFootnote();

  @override
  Widget build(BuildContext context) {
    final branch = context.watch<AvailabilityBranchCubit>().state;
    if (branch is WatchLoaded<Branch, InstitutionErrorCode>) {
      final timeline = AvailabilityTimeline(branch.data.workingHours);
      if (timeline.isEmpty) return const SizedBox.shrink();
      return AppText.caption(
        LocaleKeys.availability_timelineFootnote.translate(
          args: [timeline.axisLabel],
        ),
        tone: TextTone.muted,
      );
    }
    return const SizedBox.shrink();
  }
}
