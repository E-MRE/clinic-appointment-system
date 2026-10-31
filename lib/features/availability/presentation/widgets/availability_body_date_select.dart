part of 'availability_body.dart';

/// One-off date picker constrained by the shared one-year scheduling horizon.
final class _AvailabilityDateSelect extends StatelessWidget {
  const _AvailabilityDateSelect();

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<AvailabilityWindowDraftCubit>();
    final saving =
        context.watch<AvailabilityWindowSaveCubit>().state
            is AvailabilityWindowSaving;
    final today = AppDependency.injector.get<Clock>().today;
    final end = DateTime.utc(
      today.year,
      today.month,
      today.day,
    ).add(const Duration(days: AvailabilityConstants.oneOffHorizonDays));
    return AppDateField(
      label: LocaleKeys.availability_date.translate(),
      value: draft.state.date,
      first: today,
      last: CalendarDate.fromDateTime(end),
      enabled: !saving,
      onChanged: draft.selectDate,
    );
  }
}
