part of 'availability_body.dart';

/// Current weekday ranges, retaining removable flagged windows on closed days.
final class _AvailabilityDayWindows extends StatelessWidget {
  const _AvailabilityDayWindows({required this.day});
  final Weekday day;

  @override
  Widget build(BuildContext context) {
    final branch = context.watch<AvailabilityBranchCubit>().state;
    final availability = context.watch<StaffAvailabilityCubit>().state;
    if (branch case WatchLoaded(data: final branch)) {
      if (availability case WatchLoaded(:final data)) {
        return Wrap(
          spacing: AppSizes.s8,
          runSpacing: AppSizes.s8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final window in data.weeklyOn(day))
              _AvailabilityRangeChip(window: window),
            if (branch.workingHours.isClosedOn(day))
              AppText.body(
                LocaleKeys.availability_closed.translate(),
                tone: TextTone.muted,
              ),
          ],
        );
      }
    }
    return const SizedBox.shrink();
  }
}
