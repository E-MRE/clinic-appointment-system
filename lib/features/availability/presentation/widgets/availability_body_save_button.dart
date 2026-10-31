part of 'availability_body.dart';

/// Submits only completed valid drafts and prevents concurrent additions.
final class _AvailabilitySaveButton extends StatelessWidget {
  const _AvailabilitySaveButton({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<AvailabilityWindowDraftCubit>().state;
    final saving =
        context.watch<AvailabilityWindowAddCubit>().state
            is AvailabilityWindowSaving;
    return FilledButton(
      onPressed: draft.validWindow == null || saving
          ? null
          : context.submitAvailability,
      child: AppText.label(label, tone: TextTone.onPrimary),
    );
  }
}
