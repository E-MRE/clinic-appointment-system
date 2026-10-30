part of 'auth_startup_gate.dart';

/// Resolves the current auth state into a startup page or content child.
final class _AuthStartupGateContent extends StatelessWidget {
  const _AuthStartupGateContent({
    required this.child,
    required this.onGoHome,
    required this.router,
  });

  final Widget child;
  final VoidCallback onGoHome;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return const SplashPage();
        }
        if (state is AuthFailure) {
          return StartupErrorPage(
            kind: state.errorCode.startupErrorKind,
            onRetry: context.read<AuthCubit>().retry,
            onGoHome: onGoHome,
          );
        }
        if (state is AuthProfileFailure && _shouldShowProfileError(state)) {
          return StartupErrorPage(
            onRetry: context.read<AuthCubit>().retry,
            onSignOut: context.read<AuthCubit>().signOut,
            kind: state.errorCode.startupErrorKind,
            onGoHome: onGoHome,
          );
        }
        return child;
      },
    );
  }

  bool _shouldShowProfileError(AuthProfileFailure state) {
    return !(state.errorCode == UserErrorCode.profileMissing && _isAuthRoute);
  }

  bool get _isAuthRoute {
    final path = router.routeInformationProvider.value.uri.path;
    return path == AppRoutes.signIn ||
        path == AppRoutes.signUp ||
        path == AppRoutes.passwordReset;
  }
}
