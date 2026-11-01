part of 'availability_body.dart';

/// Opens the tablet dialog with a fresh recurring draft on an open weekday.
final class _AvailabilityAddButton extends StatelessWidget {
  const _AvailabilityAddButton();

  @override
  Widget build(BuildContext context) {
    final branch = context.watch<AvailabilityBranchCubit>().state;
    final saving =
        context.watch<AvailabilityWindowAddCubit>().state
            is AvailabilityWindowSaving;
    if (branch case WatchLoaded(:final data)) {
      return AppAddButton(
        label: LocaleKeys.availability_addWindow.translate(),
        onPressed: saving || data.workingHours.openDays.isEmpty
            ? null
            : () {
                context.read<AvailabilityWindowDraftCubit>().startWeekly(
                  data.workingHours.openDays.first,
                );
                context.openAvailabilityEditor(showsWeekdaySelect: true);
              },
      );
    }
    return const SizedBox.shrink();
  }
}
