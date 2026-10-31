part of 'availability_body.dart';

/// Paired endpoints with shared draft and save-error styling.
final class _AvailabilityTimeFields extends StatelessWidget {
  const _AvailabilityTimeFields();

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<AvailabilityWindowDraftCubit>();
    final save = context.watch<AvailabilityWindowSaveCubit>().state;
    final hasError =
        draft.state.timeError != null ||
        (save is AvailabilityWindowSaveFailure && save.code.marksTimeFields);
    return Row(
      spacing: AppSizes.s12,
      children: [
        Expanded(
          child: AppTimeField(
            label: LocaleKeys.availability_start.translate(),
            value: draft.state.start,
            hasError: hasError,
            enabled: save is! AvailabilityWindowSaving,
            onChanged: draft.changeStart,
          ),
        ),
        Expanded(
          child: AppTimeField(
            label: LocaleKeys.availability_end.translate(),
            value: draft.state.end,
            hasError: hasError,
            enabled: save is! AvailabilityWindowSaving,
            onChanged: draft.changeEnd,
          ),
        ),
      ],
    );
  }
}
