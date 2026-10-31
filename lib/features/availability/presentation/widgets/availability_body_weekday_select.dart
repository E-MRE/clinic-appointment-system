part of 'availability_body.dart';

/// Offers only branch-open weekdays when a host permits changing the weekday.
final class _AvailabilityWeekdaySelect extends StatelessWidget {
  const _AvailabilityWeekdaySelect();

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<AvailabilityWindowDraftCubit>();
    final branch = context.watch<AvailabilityBranchCubit>().state;
    final saving =
        context.watch<AvailabilityWindowSaveCubit>().state
            is AvailabilityWindowSaving;
    if (branch case WatchLoaded(:final data)) {
      final days = data.workingHours.openDays;
      return AppSelectField<Weekday>(
        label: LocaleKeys.availability_weekday.translate(),
        value: days.contains(draft.state.weekday) ? draft.state.weekday : null,
        options: [
          for (final day in days) AppSelectOption(value: day, label: day.label),
        ],
        enabled: !saving,
        onChanged: (day) {
          if (day != null) draft.selectWeekday(day);
        },
      );
    }
    return const SizedBox.shrink();
  }
}
