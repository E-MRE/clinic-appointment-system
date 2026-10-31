part of 'availability_body.dart';

/// Starts a weekday draft and opens the shared editor sheet.
final class _AvailabilityDayAddButton extends StatelessWidget {
  const _AvailabilityDayAddButton({required this.day});
  final Weekday day;

  @override
  Widget build(BuildContext context) {
    final branch = context.watch<AvailabilityBranchCubit>().state;
    final saving =
        context.watch<AvailabilityWindowSaveCubit>().state
            is AvailabilityWindowSaving;
    if (branch case WatchLoaded(:final data)) {
      if (data.workingHours.isClosedOn(day)) return const SizedBox.shrink();
      return SizedBox.square(
        dimension: AppSizes.s40,
        child: IconButton.outlined(
          style: IconButton.styleFrom(
            side: BorderSide(
              color: context.colorScheme.outlineVariant,
              width: AppSizes.borderThin,
            ),
          ),
          tooltip: LocaleKeys.availability_addForDay.translate(
            args: [day.label],
          ),
          onPressed: saving
              ? null
              : () {
                  context.read<AvailabilityWindowDraftCubit>().startWeekly(day);
                  context.read<_AvailabilityBodyActions>().openSheet(
                    context,
                    showsWeekdaySelect: false,
                  );
                },
          icon: const Icon(Icons.add, size: AppSizes.s20),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
