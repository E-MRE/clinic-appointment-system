part of 'startup_error_page.dart';

final class _StartupErrorActions extends StatelessWidget {
  const _StartupErrorActions({
    required this.kind,
    required this.isMobile,
    required this.onRetry,
    required this.onGoHome,
    this.onSignOut,
  });
  final StartupErrorKind kind;
  final bool isMobile;
  final VoidCallback onRetry;
  final VoidCallback onGoHome;
  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s8,
        children: [
          if (kind.offersRetry) _buildRetryButton(),
          if (onSignOut != null)
            _buildSignOutButton()
          else if (kind.offersGoHome)
            _buildGoHomeButton(),
        ],
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSizes.s12,
      runSpacing: AppSizes.s8,
      children: [
        if (onSignOut != null)
          _buildSignOutButton()
        else if (kind.offersGoHome)
          _buildGoHomeButton(),
        if (kind.offersRetry) _buildRetryButton(),
      ],
    );
  }

  FilledButton _buildRetryButton() {
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

  OutlinedButton _buildSignOutButton() {
    return OutlinedButton(
      onPressed: onSignOut,
      child: Text(LocaleKeys.auth_signOut.translate()),
    );
  }

  OutlinedButton _buildGoHomeButton() {
    return OutlinedButton(
      onPressed: onGoHome,
      child: Text(LocaleKeys.navigation_goHome.translate()),
    );
  }
}
