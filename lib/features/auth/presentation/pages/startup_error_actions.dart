part of 'startup_error_page.dart';

final class _StartupErrorActions extends StatelessWidget {
  const _StartupErrorActions({
    required this.kind,
    required this.onRetry,
    required this.onGoHome,
  });
  final StartupErrorKind kind;
  final VoidCallback onRetry;
  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    if (context.screenSize.isMobile) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _retryButton,
          if (kind.offersGoHome) ...[const EmptySize.smHeight(), _goHomeButton],
        ],
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSizes.md,
      runSpacing: AppSizes.sm,
      children: [if (kind.offersGoHome) _goHomeButton, _retryButton],
    );
  }

  FilledButton get _retryButton => FilledButton.icon(
    key: const WidgetKey.startupRetry(),
    onPressed: onRetry,
    icon: const _StartupRetryIcon(),
    label: Text(LocaleKeys.common_retry.translate()),
  );

  OutlinedButton get _goHomeButton => OutlinedButton(
    onPressed: onGoHome,
    child: Text(LocaleKeys.navigation_goHome.translate()),
  );
}
