import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/router/fade_transition_page.dart';
import 'package:clinic_appointment_system/core/router/home_page.dart';
import 'package:clinic_appointment_system/core/router/not_found_page.dart';
import 'package:clinic_appointment_system/features/auth/presentation/auth_route_guard.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/enums/auth_form_kind.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/auth_page.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/password_reset_page.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/sign_in_page.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/sign_up_page.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

export 'package:clinic_appointment_system/core/router/app_routes.dart';

/// Defines application routes using page-owned Cubit factories supplied by DI.
/// Auth screens share one shell; registration and reset stack on sign-in.
GoRouter createAppRouter({
  String? initialLocation,
  AuthRouteGuard? authGuard,
  SignInCubit Function()? signInCubitFactory,
  SignUpCubit Function()? signUpCubitFactory,
  PasswordResetCubit Function()? passwordResetCubitFactory,
  GoRouterRedirect? redirect,
  Listenable? refreshListenable,
}) {
  return GoRouter(
    initialLocation: initialLocation,
    redirect: redirect ?? authGuard?.redirect,
    refreshListenable: refreshListenable ?? authGuard,
    errorBuilder: (context, state) => const NotFoundPage(),
    routes: [
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (_, state) {
          return _fadePage(state, const HomePage());
        },
      ),
      if (signInCubitFactory != null)
        ShellRoute(
          pageBuilder: (_, state, child) {
            return _fadePage(
              state,
              AuthShell(
                kind: AuthFormKind.fromLocation(state.uri.path),
                child: child,
              ),
            );
          },
          routes: [
            GoRoute(
              path: AppRoutes.signIn,
              pageBuilder: (_, state) {
                return _fadePage(
                  state,
                  SignInPage(createCubit: signInCubitFactory),
                );
              },
              routes: [
                if (signUpCubitFactory != null)
                  GoRoute(
                    path: AppRoutes.signUpSegment,
                    pageBuilder: (_, state) {
                      return _fadePage(
                        state,
                        SignUpPage(createCubit: signUpCubitFactory),
                      );
                    },
                  ),
                if (passwordResetCubitFactory != null)
                  GoRoute(
                    path: AppRoutes.passwordResetSegment,
                    pageBuilder: (_, state) {
                      return _fadePage(
                        state,
                        PasswordResetPage(
                          createCubit: passwordResetCubitFactory,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ],
        ),
    ],
  );
}

/// Keys the page by its route so stack changes animate in both directions.
Page<void> _fadePage(GoRouterState state, Widget child) {
  return FadeTransitionPage<void>(key: state.pageKey, child: child);
}
