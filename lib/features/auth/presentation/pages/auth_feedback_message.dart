part of 'auth_page.dart';

/// Displays and announces a request message once when it changes.
final class _AuthFeedbackMessage extends StatelessWidget {
  const _AuthFeedbackMessage({required this.message, required this.color});

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const WidgetKey.authFeedback(),
      padding: const AppPadding.verticalLg(),
      child: AnnouncedSemantics(
        label: message,
        child: Text(
          message,
          style: context.textTheme.bodyMedium?.copyWith(color: color),
        ),
      ),
    );
  }
}
