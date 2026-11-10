import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_destination.dart';
import 'package:clinic_appointment_system/features/patient/presentation/enums/patient_destination.dart';
import 'package:flutter/material.dart';

/// Navigation appearance and location matching for patient destinations.
extension PatientDestinationNavigation on PatientDestination {
  /// The localized shell navigation item.
  AppNavigationDestination get destination {
    return switch (this) {
      PatientDestination.appointments => AppNavigationDestination(
        label: LocaleKeys.patient_appointments_title.translate(),
        icon: Icons.assignment_outlined,
        selectedIcon: Icons.assignment,
      ),
      PatientDestination.book => AppNavigationDestination(
        label: LocaleKeys.patient_book_title.translate(),
        icon: Icons.edit_calendar_outlined,
        selectedIcon: Icons.edit_calendar,
      ),
    };
  }

  /// Whether this destination owns [path].
  bool matches(String path) => path == route || path.startsWith('$route/');
}
