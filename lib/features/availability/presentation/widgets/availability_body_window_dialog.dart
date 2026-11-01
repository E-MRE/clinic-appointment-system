part of 'availability_body.dart';

/// Tablet form dialog retaining failed drafts until a successful save.
final class _AvailabilityWindowDialog extends StatelessWidget {
  const _AvailabilityWindowDialog();

  @override
  Widget build(BuildContext context) {
    return _AvailabilityWindowSaveScope(
      child: AppFormDialog(
        title: LocaleKeys.availability_addWindow.translate(),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSizes.s16,
          children: [
            _AvailabilityWindowForm(showsWeekdaySelect: true),
            _AvailabilityDialogActions(),
          ],
        ),
      ),
    );
  }
}
