part of 'startup_error_page.dart';

final class _StartupErrorActions extends StatelessWidget {
  const _StartupErrorActions({
    required this.kind,
    required this.isMobile,
    required this.onRetry,
    required this.onGoHome,
  });
  final StartupErrorKind kind;
  final bool isMobile;
  final VoidCallback onRetry;
  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _retryButton,
          if (kind.offersGoHome) ...[const EmptySize.s8Height(), _goHomeButton],
        ],
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSizes.s12,
      runSpacing: AppSizes.s8,
      children: [if (kind.offersGoHome) _goHomeButton, _retryButton],
    );
  }

  FilledButton get _retryButton {
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

  OutlinedButton get _goHomeButton {
    return OutlinedButton(
      onPressed: onGoHome,
      child: Text(LocaleKeys.navigation_goHome.translate()),
    );
  }
}
