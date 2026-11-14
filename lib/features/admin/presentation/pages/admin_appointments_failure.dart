part of 'admin_appointments_page.dart';

/// Recoverable data failure with a retry for its owning observation.
final class _AdminAppointmentsFailure extends StatelessWidget {
  const _AdminAppointmentsFailure({
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
