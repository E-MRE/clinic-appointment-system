part of 'availability_body.dart';

/// Recurrence selection preserved while switching between weekly and dated drafts.
final class _AvailabilityRepeatControl extends StatelessWidget {
  const _AvailabilityRepeatControl();

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<AvailabilityWindowDraftCubit>();
    final saving =
        context.watch<AvailabilityWindowSaveCubit>().state
            is AvailabilityWindowSaving;
    return AppSegmentedControl<AvailabilityRepeat>(
      selected: draft.state.repeat,
      enabled: !saving,
      choices: [
        AppChoice(
          value: AvailabilityRepeat.weekly,
          label: LocaleKeys.availability_weekly.translate(),
        ),
        AppChoice(
          value: AvailabilityRepeat.oneOff,
          label: LocaleKeys.availability_oneOff.translate(),
        ),
      ],
      onSelected: draft.selectRepeat,
    );
  }
}
