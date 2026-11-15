part of 'admin_home_page.dart';

/// Shows the cancel and confirmation actions for the demo data dialog.
final class _AdminHomeDemoDataDialogActions extends StatelessWidget {
  /// Creates dialog actions with the configured confirmation label and tone.
  const _AdminHomeDemoDataDialogActions({
    required this.actionLabel,
    required this.actionTone,
    this.actionStyle,
  });

  final String actionLabel;
  final TextTone actionTone;
  final ButtonStyle? actionStyle;

  @override
  Widget build(BuildContext context) {
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
          style: actionStyle,
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: AppText.label(actionLabel, tone: actionTone),
        ),
      ],
    );
  }
}
