part of 'auth_page.dart';

/// Displays and announces a request message once when it changes.
final class _AuthFeedbackMessage extends StatelessWidget {
  const _AuthFeedbackMessage({required this.message, required this.tone});

  final String message;
  final TextTone tone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const WidgetKey.authFeedback(),
      padding: const AppPadding.verticalLg(),
      child: AnnouncedSemantics(
        label: message,
        child: AppText.body(message, tone: tone),
      ),
    );
  }
}
