part of 'institution_list_view.dart';

/// Shared institution list failure with retry.
final class _InstitutionListFailure extends StatelessWidget {
  const _InstitutionListFailure({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ErrorState(
      title: LocaleKeys.institution_errors_unavailable.tr(),
      message: message,
      icon: const Icon(Icons.error_outline),
      iconBackground: context.colorScheme.errorContainer,
      primaryAction: FilledButton(
        onPressed: onRetry,
        child: AppText.label(
          LocaleKeys.institution_retry.tr(),
          tone: TextTone.onPrimary,
        ),
      ),
    );
  }
}
