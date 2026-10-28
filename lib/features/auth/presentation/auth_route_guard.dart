import 'dart:async';

import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_appointment_system/features/auth/presentation/extensions/user_role_home.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
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
    return state is AuthSignedIn && _wasAwaitingSignIn;
  }

  /// Whether the previous state still waited for a session or its profile.
  bool get _wasAwaitingSignIn {
    if (_previous is AuthSignedOut) {
      return true;
    }

    if (_previous is AuthProfileFailure) {
      return (_previous as AuthProfileFailure).isProfileMissing;
    }

    return false;
  }

  void _onSessionChanged(AuthState state) {
    final skipsRefresh = _isSignedInByRequest(state);
    _previous = state;
    if (skipsRefresh) {
      return;
    }
    notifyListeners();
  }

  /// Redirects home and authentication locations according to the session.
  String? redirect(BuildContext context, GoRouterState route) {
    final path = route.uri.path;
    final state = _authCubit.state;

    if (state is AuthSignedOut) {
      if (_isProtectedHome(path)) {
        return AppRoutes.signIn;
      }
    }

    if (state is AuthSignedIn) {
      final user = state.user;

      if (_needsHomeRedirect(path, user.role.homePath)) {
        return user.role.homePath;
      }
    }

    return null;
  }

  /// Role homes come from the role mapping, so a new role needs no edit here.
  bool _isRoleHomeOrDescendant(String path) {
    return UserRole.values.any((role) => _isWithin(path, role.homePath));
  }

  /// Whether [path] is [root] itself or a location nested under it.
  bool _isWithin(String path, String root) {
    return path == root || path.startsWith('$root/');
  }

  bool _isProtectedHome(String path) {
    return path == AppRoutes.home || _isRoleHomeOrDescendant(path);
  }

  bool _isAuthLocation(String path) => _isWithin(path, AppRoutes.signIn);

  bool _isOtherRoleHome(String path, String home) {
    return _isRoleHomeOrDescendant(path) && !_isWithin(path, home);
  }

  bool _needsHomeRedirect(String path, String home) {
    return path == AppRoutes.home ||
        _isAuthLocation(path) ||
        _isOtherRoleHome(path, home);
  }

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
