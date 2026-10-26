import 'dart:async';

import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Refreshes routing when the session changes and protects authenticated routes.
/// Route definitions and page construction belong to the application router.
final class AuthRouteGuard extends ChangeNotifier {
  AuthRouteGuard(this._authCubit) {
    _subscription = _authCubit.stream.listen(_onSessionChanged);
  }

  final AuthCubit _authCubit;
  late final StreamSubscription<AuthState> _subscription;

  void _onSessionChanged(AuthState state) {
    notifyListeners();
  }

  /// Sends signed-out home requests to sign-in while preserving unknown routes.
  String? redirect(BuildContext context, GoRouterState route) {
    if (_authCubit.state is AuthSignedOut && route.uri.path == AppRoutes.home) {
      return AppRoutes.signIn;
    }
    return null;
  }

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
