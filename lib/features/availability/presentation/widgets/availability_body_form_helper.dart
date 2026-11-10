part of 'availability_body.dart';

/// Selected weekday's allowable branch ranges and overlap guidance.
final class _AvailabilityFormHelper extends StatelessWidget {
  const _AvailabilityFormHelper();

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<AvailabilityWindowDraftCubit>().state;
    final branch = context.watch<AvailabilityBranchCubit>().state;
    if (branch is WatchLoaded<Branch, InstitutionErrorCode>) {
      return AppText.caption(
        branch.data.availabilityHelper(draft.selectedDay),
        tone: TextTone.muted,
      );
    }
    return const SizedBox.shrink();
  }
}
