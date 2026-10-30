part of 'startup_error_page.dart';

/// Retry button for startup error actions.
final class _StartupRetryButton extends StatelessWidget {
  const _StartupRetryButton({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      key: const WidgetKey.startupRetry(),
      onPressed: onRetry,
      icon: SquareSvgIcon(
        asset: Assets.images.status.retry,
        size: AppSizes.s20,
      ),
      label: Text(LocaleKeys.common_retry.translate()),
    );
  }
}
