part of 'availability_body.dart';

/// Shared recurrence, day/date and time editor for sheet, dialog and panel hosts.
final class _AvailabilityWindowForm extends StatelessWidget {
  const _AvailabilityWindowForm({required this.showsWeekdaySelect});
  final bool showsWeekdaySelect;

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<AvailabilityWindowDraftCubit>().state;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s16,
      children: [
        const _AvailabilityRepeatControl(),
        if (draft.repeat == AvailabilityRepeat.oneOff)
          const _AvailabilityDateSelect()
        else if (showsWeekdaySelect)
          const _AvailabilityWeekdaySelect(),
        const _AvailabilityTimeFields(),
        const _AvailabilityFormHelper(),
        const _AvailabilityFormError(),
      ],
    );
  }
}
