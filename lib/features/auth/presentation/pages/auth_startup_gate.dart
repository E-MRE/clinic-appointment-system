import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_appointment_system/features/auth/presentation/extensions/auth_error_code_startup_error.dart';
import 'package:clinic_appointment_system/features/auth/presentation/extensions/user_error_code_startup_error.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/splash_page.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/startup_error_page.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Holds the current route behind Splash until session restoration completes.
/// Route-specific access rules are applied separately by the router.
final class AuthStartupGate extends StatelessWidget {
  const AuthStartupGate({
    required this.child,
    required this.onGoHome,
    required this.router,
    super.key,
  });

  /// Router whose current location determines whether a missing profile is shown.
  final GoRouter router;
  final Widget child;
  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: router.routeInformationProvider,
      builder: (context, _) {
        return _buildContent(context);
      },
    );
  }

  /// Resolves the current auth state into a startup page or content child.
  Widget _buildContent(BuildContext context) {
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
