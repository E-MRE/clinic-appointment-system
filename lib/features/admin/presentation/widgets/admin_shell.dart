import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_shell.dart';
import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_destination.dart';
import 'package:clinic_appointment_system/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Keeps administrator destinations visible at every screen size.
final class AdminShell extends StatelessWidget {
  const AdminShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final destination = AdminDestination.fromLocation(location);
    return AppNavigationShell(
      logo: Assets.images.brand.clinicLogo,
      selectedIndex: destination.index,
      onDestinationSelected: (index) {
        context.go(AdminDestination.values[index].route);
      },
      destinations: [
        for (final item in AdminDestination.values) item.destination,
      ],
      child: child,
    );
  }
}
