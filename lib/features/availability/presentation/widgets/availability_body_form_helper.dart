part of 'availability_body.dart';

/// Selected weekday's allowable branch ranges and overlap guidance.
final class _AvailabilityFormHelper extends StatelessWidget {
  const _AvailabilityFormHelper();

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<AvailabilityWindowDraftCubit>().state;
    if (context.watch<AvailabilityBranchCubit>().state case WatchLoaded(
      :final data,
    )) {
      return AppText.caption(
        data.availabilityHelper(draft.selectedDay),
        tone: TextTone.muted,
      );
    }
    return const SizedBox.shrink();
  }
}
