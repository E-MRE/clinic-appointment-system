import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_destination.dart';
import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_destination.dart';
import 'package:flutter/material.dart';

/// Navigation appearance and location matching for staff destinations.
extension StaffDestinationNavigation on StaffDestination {
  /// The localized shell navigation item.
  AppNavigationDestination get destination {
    return AppNavigationDestination(
      label: LocaleKeys.availability_title.translate(),
      icon: Icons.schedule_outlined,
      selectedIcon: Icons.schedule,
    );
  }

  /// Whether this destination owns [path].
  bool matches(String path) => path == route || path.startsWith('$route/');
}
