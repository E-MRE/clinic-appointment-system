part of 'availability_body.dart';

/// Branch identity and visible hours, avoiding a midnight axis for closed weeks.
final class _AvailabilityBranchCaption extends StatelessWidget {
  const _AvailabilityBranchCaption();

  @override
  Widget build(BuildContext context) {
    if (context.watch<AvailabilityBranchCubit>().state case WatchLoaded(
      :final data,
    )) {
      final timeline = AvailabilityTimeline(data.workingHours);
      return AppText.caption(
        LocaleKeys.availability_branchAxis.translate(
          args: [
            data.name,
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
