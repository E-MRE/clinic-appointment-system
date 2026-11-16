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
        return _AvailabilityTimelineLoadedTrack(
          day: day,
          timeline: timeline,
          branch: branch.data,
          availability: availability.data,
          pending: pending,
        );
      }
    }
    return const SizedBox.shrink();
  }
}
