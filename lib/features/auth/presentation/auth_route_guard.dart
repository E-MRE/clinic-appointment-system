import 'dart:async';

import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Refreshes routing when the session changes and protects authenticated routes.
/// Route definitions and page construction belong to the application router.
final class AuthRouteGuard extends ChangeNotifier {
  AuthRouteGuard(this._authCubit) : _previous = _authCubit.state {
    _subscription = _authCubit.stream.listen(_onSessionChanged);
  }

  final AuthCubit _authCubit;
  late final StreamSubscription<AuthState> _subscription;
  AuthState _previous;

  /// A form request signed in; the form opens home after its request finishes,
  /// so a refresh here would hide a failure such as the profile-name update.
  bool _isSignedInByRequest(AuthState state) {
    return _previous is AuthSignedOut && state is AuthSignedIn;
  }

  void _onSessionChanged(AuthState state) {
    final skipsRefresh = _isSignedInByRequest(state);
    _previous = state;
    if (skipsRefresh) {
      return;
    }
    notifyListeners();
  }

  /// Sends signed-out home requests to sign-in and signed-in auth requests to
  /// home, while preserving unknown routes.
  String? redirect(BuildContext context, GoRouterState route) {
    final state = _authCubit.state;
    final path = route.uri.path;
    if (state is AuthSignedOut && path == AppRoutes.home) {
      return AppRoutes.signIn;
    }
    if (state is AuthSignedIn && _isAuthLocation(path)) {
      return AppRoutes.home;
    }
    return null;
  }

  bool _isAuthLocation(String path) {
    return path == AppRoutes.signIn || path.startsWith('${AppRoutes.signIn}/');
  }

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
