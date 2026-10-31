part of 'availability_body.dart';

/// Right-aligned tablet cancellation and submission actions.
final class _AvailabilityDialogActions extends StatelessWidget {
  const _AvailabilityDialogActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: AppSizes.s8,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: AppText.label(
            LocaleKeys.availability_cancel.translate(),
            tone: TextTone.primary,
          ),
        ),
        _AvailabilitySaveButton(
          label: LocaleKeys.availability_save.translate(),
        ),
      ],
    );
  }
}
