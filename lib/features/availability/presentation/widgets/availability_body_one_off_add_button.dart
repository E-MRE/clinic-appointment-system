part of 'availability_body.dart';

/// Starts a dated draft with access to recurrence and weekday selection.
final class _AvailabilityOneOffAddButton extends StatelessWidget {
  const _AvailabilityOneOffAddButton();

  @override
  Widget build(BuildContext context) {
    final saving =
        context.watch<AvailabilityWindowSaveCubit>().state
            is AvailabilityWindowSaving;
    return OutlinedButton.icon(
      onPressed: saving
          ? null
          : () {
              context.read<AvailabilityWindowDraftCubit>().startOneOff();
              context.read<_AvailabilityBodyActions>().openSheet(
                context,
                showsWeekdaySelect: true,
              );
            },
      icon: const Icon(Icons.add),
      label: AppText.label(
        LocaleKeys.availability_addForDate.translate(),
        tone: TextTone.primary,
      ),
    );
  }
}
