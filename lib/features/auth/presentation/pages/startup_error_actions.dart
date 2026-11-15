part of 'startup_error_page.dart';

/// Selects the matching layout for startup error actions.
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
      return _buildMobile();
    }

    return _buildDesktop();
  }

  /// Builds the vertical action layout used on mobile.
  Widget _buildMobile() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s8,
      children: [
        if (kind.config.offersRetry) _StartupRetryButton(onRetry: onRetry),
        if (onSignOut != null || kind.config.offersGoHome)
          _StartupSecondaryActionButton(
            onSignOut: onSignOut,
            onGoHome: onGoHome,
          ),
      ],
    );
  }

  /// Builds the centered action wrap used on tablet and desktop.
  Widget _buildDesktop() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSizes.s12,
      runSpacing: AppSizes.s8,
      children: [
        if (onSignOut != null || kind.config.offersGoHome)
          _StartupSecondaryActionButton(
            onSignOut: onSignOut,
            onGoHome: onGoHome,
          ),
        if (kind.config.offersRetry) _StartupRetryButton(onRetry: onRetry),
      ],
    );
  }
}
