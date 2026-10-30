part of 'startup_error_page.dart';

/// Sign out or go home secondary button for startup error actions.
final class _StartupSecondaryActionButton extends StatelessWidget {
  const _StartupSecondaryActionButton({
    required this.onSignOut,
    required this.onGoHome,
  });

  final VoidCallback? onSignOut;
  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    if (onSignOut case final signOut?) {
      return OutlinedButton(
        onPressed: signOut,
        child: Text(LocaleKeys.auth_signOut.translate()),
      );
    }
    return OutlinedButton(
      onPressed: onGoHome,
      child: Text(LocaleKeys.navigation_goHome.translate()),
    );
  }
}
