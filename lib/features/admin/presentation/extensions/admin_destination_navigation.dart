import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_destination.dart';
import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_destination.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Shell navigation item and route matching of an [AdminDestination].
extension AdminDestinationNavigation on AdminDestination {
  /// Navigation shell configuration item for this destination.
  AppNavigationDestination get destination {
    return switch (this) {
      AdminDestination.overview => AppNavigationDestination(
        label: LocaleKeys.institution_overview.tr(),
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
      ),
      AdminDestination.institution => AppNavigationDestination(
        label: LocaleKeys.institution_clinic.tr(),
        icon: Icons.business_outlined,
        selectedIcon: Icons.business,
      ),
      AdminDestination.services => AppNavigationDestination(
        label: LocaleKeys.services_title.tr(),
        icon: Icons.medical_services_outlined,
        selectedIcon: Icons.medical_services,
      ),
      AdminDestination.staff => AppNavigationDestination(
        label: LocaleKeys.staff_title.tr(),
        icon: Icons.group_outlined,
        selectedIcon: Icons.group,
      ),
    };
  }

  /// Whether [path] belongs to this admin destination; the overview matches
  /// only its own route because every admin route starts with it.
  bool matches(String path) {
    if (this == AdminDestination.overview) return path == route;
    return path == route || path.startsWith('$route/');
  }
}
