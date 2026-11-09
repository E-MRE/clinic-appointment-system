part of 'staff_requests_page.dart';

/// Recoverable failure that restarts the request observation.
final class _StaffRequestsFailure extends StatelessWidget {
  const _StaffRequestsFailure({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ErrorState(
      title: LocaleKeys.staffRequests_failureTitle.translate(),
      message: message,
      icon: Icon(
        Icons.error_outline,
        color: context.colorScheme.onErrorContainer,
      ),
      iconBackground: context.colorScheme.errorContainer,
      primaryAction: FilledButton(
        onPressed: context.read<StaffRequestsCubit>().retry,
        child: AppText.label(
          LocaleKeys.staffRequests_retry.translate(),
          tone: TextTone.onPrimary,
        ),
      ),
    );
  }
}
