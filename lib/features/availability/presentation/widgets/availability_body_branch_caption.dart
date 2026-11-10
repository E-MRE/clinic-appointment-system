part of 'availability_body.dart';

/// Branch identity and visible hours, avoiding a midnight axis for closed weeks.
final class _AvailabilityBranchCaption extends StatelessWidget {
  const _AvailabilityBranchCaption();

  @override
  Widget build(BuildContext context) {
    final branch = context.watch<AvailabilityBranchCubit>().state;
    if (branch is WatchLoaded<Branch, InstitutionErrorCode>) {
      final timeline = AvailabilityTimeline(branch.data.workingHours);
      return AppText.caption(
        LocaleKeys.availability_branchAxis.translate(
          args: [
            branch.data.name,
            timeline.isEmpty
                ? LocaleKeys.availability_closed.translate()
                : timeline.axisLabel,
          ],
        ),
        tone: TextTone.muted,
        textAlign: TextAlign.end,
      );
    }
    return const SizedBox.shrink();
  }
}
