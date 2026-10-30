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
      return _StartupErrorMobileActions(
        kind: kind,
        onRetry: onRetry,
        onGoHome: onGoHome,
        onSignOut: onSignOut,
      );
    }

    return _StartupErrorDesktopActions(
      kind: kind,
      onRetry: onRetry,
      onGoHome: onGoHome,
      onSignOut: onSignOut,
    );
  }
}
