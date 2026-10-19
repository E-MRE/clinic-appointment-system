import 'package:clinic_appointment_system/core/router/home_page.dart';
import 'package:clinic_appointment_system/core/router/not_found_page.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRoutes {
  static const home = '/';
}

/// Auth can supply redirect and refreshListenable when sessions are introduced.
GoRouter createAppRouter({
  String? initialLocation,
  GoRouterRedirect? redirect,
  Listenable? refreshListenable,
}) => GoRouter(
  initialLocation: initialLocation,
  redirect: redirect,
  refreshListenable: refreshListenable,
  routes: [GoRoute(path: AppRoutes.home, builder: (_, _) => const HomePage())],
  errorBuilder: (_, _) => const NotFoundPage(),
);
