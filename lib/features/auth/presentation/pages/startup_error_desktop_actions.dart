part of 'startup_error_page.dart';

/// Horizontal action wrap for desktop and tablet startup errors.
final class _StartupErrorDesktopActions extends StatelessWidget {
  const _StartupErrorDesktopActions({
    required this.kind,
    required this.onRetry,
    required this.onGoHome,
    required this.onSignOut,
  });

  final StartupErrorKind kind;
  final VoidCallback onRetry;
  final VoidCallback onGoHome;
  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSizes.s12,
      runSpacing: AppSizes.s8,
      children: [
        if (onSignOut != null || kind.offersGoHome)
          _StartupSecondaryActionButton(
            onSignOut: onSignOut,
            onGoHome: onGoHome,
          ),
        if (kind.offersRetry) _StartupRetryButton(onRetry: onRetry),
      ],
    );
  }
}
