import 'package:clinic_appointment_system/core/router/app_routes.dart';

/// Navigation destinations presented in the administrator shell.
enum AdminDestination {
  /// Dashboard and summary cards.
  overview(AppRoutes.adminHome),

  /// Institution hierarchy: clinics, branches and departments.
  institution(AppRoutes.institution),

  /// Clinical, imaging and laboratory medical services.
  services(AppRoutes.services);

  const AdminDestination(this.route);

  /// The root route location for this destination.
  final String route;
}
