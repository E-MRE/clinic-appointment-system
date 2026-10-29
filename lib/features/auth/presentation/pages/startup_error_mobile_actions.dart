part of 'startup_error_page.dart';

/// Vertical action column for mobile startup errors.
final class _StartupErrorMobileActions extends StatelessWidget {
  const _StartupErrorMobileActions({
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s8,
      children: [
        if (kind.offersRetry) _StartupRetryButton(onRetry: onRetry),
        if (onSignOut != null || kind.offersGoHome)
          _StartupSecondaryActionButton(
            onSignOut: onSignOut,
            onGoHome: onGoHome,
          ),
      ],
    );
  }
}
