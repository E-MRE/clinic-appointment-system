import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_destination.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Navigation destinations presented in the administrator shell.
enum AdminDestination {
  /// Dashboard and summary cards.
  overview(
    route: AppRoutes.adminHome,
    labelKey: LocaleKeys.institution_overview,
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
  ),

  /// Institution hierarchy: clinics, branches and departments.
  institution(
    route: AppRoutes.institution,
    labelKey: LocaleKeys.institution_clinic,
    icon: Icons.business_outlined,
    selectedIcon: Icons.business,
  ),

  /// Clinical, imaging and laboratory medical services.
  services(
    route: AppRoutes.services,
    labelKey: LocaleKeys.services_title,
    icon: Icons.medical_services_outlined,
    selectedIcon: Icons.medical_services,
  );

  const AdminDestination({
    required this.route,
    required this.labelKey,
    required this.icon,
    required this.selectedIcon,
  });

  /// The root route location for this destination.
  final String route;

  /// Translation key for this destination's visible label.
  final String labelKey;

  /// Icon used when this destination is not active.
  final IconData icon;

  /// Icon used when this destination is active.
  final IconData selectedIcon;

  /// Whether [path] belongs to this admin destination.
  bool matches(String path) {
    if (this == overview) return path == route;
    return path == route || path.startsWith('$route/');
  }

  /// Finds the matching destination for [path], falling back to [overview].
  static AdminDestination fromLocation(String path) => values.firstWhere(
    (destination) => destination.matches(path),
    orElse: () => overview,
  );

  /// Navigation shell configuration item for this destination.
  AppNavigationDestination get destination => AppNavigationDestination(
    label: labelKey.tr(),
    icon: icon,
    selectedIcon: selectedIcon,
  );
}
