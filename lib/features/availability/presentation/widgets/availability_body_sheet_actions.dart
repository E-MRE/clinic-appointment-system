part of 'availability_body.dart';

/// Validated add submission and cancellation with draft cleanup on dismissal.
final class _AvailabilitySheetActions extends StatelessWidget {
  const _AvailabilitySheetActions();

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<AvailabilityWindowDraftCubit>().state;
    final save = context.watch<AvailabilityWindowSaveCubit>();
    final saving = save.state is AvailabilityWindowSaving;
    // Check timeError before window: constructing an invalid range throws.
    final window = draft.timeError == null ? draft.window : null;
    return AppSheetActions(
      cancelLabel: LocaleKeys.availability_cancel.translate(),
      confirmLabel: LocaleKeys.availability_save.translate(),
      isBusy: saving,
      onCancel: () {
        Navigator.of(context).pop();
        context.read<AvailabilityWindowDraftCubit>().reset();
        save.reset();
      },
      onConfirm: window == null || saving
          ? null
          : () {
              save.add(context.read<AvailabilitySubject>(), window);
            },
    );
  }
}
