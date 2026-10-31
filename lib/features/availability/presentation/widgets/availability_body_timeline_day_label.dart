part of 'availability_body.dart';

/// Full weekday label above its recurring duration total.
final class _AvailabilityTimelineDayLabel extends StatelessWidget {
  const _AvailabilityTimelineDayLabel({required this.day});
  final Weekday day;

  @override
  Widget build(BuildContext context) {
    final availability = context.watch<StaffAvailabilityCubit>().state;
    final branch = context.watch<AvailabilityBranchCubit>().state;
    if (availability case WatchLoaded(:final data)) {
      if (branch case WatchLoaded(data: final branch)) {
        return SizedBox(
          width: context.screenSize.select(
            mobile: AppSizes.availabilityTimelineLabelTablet,
            tablet: AppSizes.availabilityTimelineLabelTablet,
            desktop: AppSizes.s96,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.bodyStrong(day.label),
              AppText.caption(
                branch.workingHours.isClosedOn(day)
                    ? LocaleKeys.availability_noMinutes.translate()
                    : data.minutesOn(day).availabilityLabel,
                tone: TextTone.muted,
              ),
            ],
          ),
        );
      }
    }
    return const SizedBox.shrink();
  }
}
