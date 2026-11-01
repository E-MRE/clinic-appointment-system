part of 'availability_body.dart';

/// Closed-day dashed outline or neutral open-day track.
final class _AvailabilityTimelineBackground extends StatelessWidget {
  const _AvailabilityTimelineBackground({required this.day});
  final Weekday day;

  @override
  Widget build(BuildContext context) {
    if (context.watch<AvailabilityBranchCubit>().state case WatchLoaded(
      :final data,
    )) {
      if (data.workingHours.isClosedOn(day)) {
        return AppDashedBorder(
          color: context.colorScheme.outlineVariant,
          strokeWidth: AppSizes.borderThin,
          radius: const AppRadius.small(),
          child: Center(
            child: AppText.body(
              LocaleKeys.availability_closed.translate(),
              tone: TextTone.muted,
            ),
          ),
        );
      }
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const AppRadius.small(),
        border: Border.all(
          color: context.colorScheme.outlineVariant,
          width: AppSizes.borderThin,
        ),
      ),
    );
  }
}
