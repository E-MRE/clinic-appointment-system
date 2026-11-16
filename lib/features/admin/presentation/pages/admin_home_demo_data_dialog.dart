part of 'admin_home_page.dart';

/// Confirms the admin's request to replace seeded demo and institution data.
final class _AdminHomeDemoDataDialog extends StatelessWidget {
  /// Creates a configurable confirmation dialog for a demo data command.
  const _AdminHomeDemoDataDialog({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.actionTone,
    this.actionStyle,
  });

  final String title;
  final String message;
  final String actionLabel;
  final TextTone actionTone;
  final ButtonStyle? actionStyle;

  @override
  Widget build(BuildContext context) {
    return AppFormDialog(
      title: title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText.body(message),
          const EmptySize.s16Height(),
          _AdminHomeDemoDataDialogActions(
            actionLabel: actionLabel,
            actionTone: actionTone,
            actionStyle: actionStyle,
          ),
        ],
      ),
    );
  }
}
