import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/splash_page.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/startup_error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds the current route behind Splash until session restoration completes.
/// Route-specific access rules are applied separately by the router.
final class AuthStartupGate extends StatelessWidget {
  const AuthStartupGate({
    required this.child,
    required this.onGoHome,
    super.key,
  });
  final Widget child;
  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) => BlocBuilder<AuthCubit, AuthState>(
    builder: (context, state) => switch (state) {
      AuthInitial() || AuthLoading() => const SplashPage(),
      AuthFailure(:final errorCode) => StartupErrorPage(
        errorCode: errorCode,
        onRetry: context.read<AuthCubit>().retry,
        onGoHome: onGoHome,
      ),
      AuthSignedIn() || AuthSignedOut() => child,
    },
  );
}
