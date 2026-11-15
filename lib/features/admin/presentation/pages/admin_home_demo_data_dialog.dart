part of 'admin_home_page.dart';

/// Confirms the admin's request to replace seeded demo and institution data.
final class _AdminHomeDemoDataDialog extends StatelessWidget {
  /// Creates the demo data confirmation dialog.
  const _AdminHomeDemoDataDialog();

  @override
  Widget build(BuildContext context) {
    return AppFormDialog(
      title: LocaleKeys.demoData_confirmTitle.translate(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText.body(LocaleKeys.demoData_confirmMessage.translate()),
          const EmptySize.s16Height(),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: AppSizes.s8,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: AppText.label(LocaleKeys.common_cancel.translate()),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: AppText.label(
            LocaleKeys.demoData_confirmAction.translate(),
            tone: TextTone.onPrimary,
          ),
        ),
      ],
    );
  }
}
