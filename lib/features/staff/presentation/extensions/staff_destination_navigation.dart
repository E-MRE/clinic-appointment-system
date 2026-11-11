import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_destination.dart';
import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_destination.dart';
import 'package:flutter/material.dart';

/// Navigation appearance and location matching for staff destinations.
extension StaffDestinationNavigation on StaffDestination {
  /// The localized shell navigation item, optionally displaying [badgeCount].
  AppNavigationDestination destination({int? badgeCount}) {
    return switch (this) {
      StaffDestination.requests => AppNavigationDestination(
        label: LocaleKeys.staffRequests_title.translate(),
        icon: Icons.inbox_outlined,
        selectedIcon: Icons.inbox,
        badgeCount: badgeCount,
      ),
      StaffDestination.availability => AppNavigationDestination(
        label: LocaleKeys.availability_title.translate(),
        icon: Icons.schedule_outlined,
        selectedIcon: Icons.schedule,
        badgeCount: badgeCount,
      ),
    };
  }

  /// Whether this destination owns [path].
  bool matches(String path) => path == route || path.startsWith('$route/');
}
