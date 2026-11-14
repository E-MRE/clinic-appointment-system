part of 'admin_home_page.dart';

/// Shows a recoverable dashboard or catalog error with a retry action.
final class _AdminHomeFailureState extends StatelessWidget {
  const _AdminHomeFailureState({
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ErrorState(
      title: title,
      message: message,
      icon: Icon(
        Icons.error_outline,
        color: context.colorScheme.onErrorContainer,
      ),
      iconBackground: context.colorScheme.errorContainer,
      primaryAction: FilledButton(
        onPressed: onRetry,
        child: AppText.label(
          LocaleKeys.admin_appointmentsPage_retry.translate(),
          tone: TextTone.onPrimary,
        ),
      ),
    );
  }
}
