import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_shell.dart';
import 'package:clinic_appointment_system/generated/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Keeps the two implemented administrator destinations visible at every size.
final class AdminShell extends StatelessWidget {
  const AdminShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final institutionSelected = GoRouterState.of(
      context,
    ).uri.path.startsWith(AppRoutes.institution);
    return AppNavigationShell(
      logo: Assets.images.brand.clinicLogo,
      selectedIndex: institutionSelected ? 1 : 0,
      onDestinationSelected: (index) {
        context.go(index == 0 ? AppRoutes.adminHome : AppRoutes.institution);
      },
      destinations: [
        AppNavigationDestination(
          label: LocaleKeys.institution_overview.tr(),
          icon: Icons.dashboard_outlined,
          selectedIcon: Icons.dashboard,
        ),
        AppNavigationDestination(
          label: LocaleKeys.institution_clinic.tr(),
          icon: Icons.business_outlined,
          selectedIcon: Icons.business,
        ),
      ],
      child: child,
    );
  }
}
