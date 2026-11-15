import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_shell.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_user_card.dart';
import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_destination.dart';
import 'package:clinic_appointment_system/features/admin/presentation/extensions/admin_destination_navigation.dart';
import 'package:clinic_appointment_system/features/admin/presentation/extensions/admin_location_destination.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_appointment_system/features/users/presentation/extensions/user_display_name.dart';
import 'package:clinic_appointment_system/generated/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'admin_shell_user_card.dart';

/// Keeps administrator destinations visible at every screen size.
final class AdminShell extends StatelessWidget {
  const AdminShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final destination = location.adminDestination;
    return AppNavigationShell(
      logo: Assets.images.brand.clinicLogo,
      selectedIndex: destination.index,
      onDestinationSelected: (index) {
        context.go(AdminDestination.values[index].route);
      },
      destinations: [
        for (final item in AdminDestination.values) item.destination,
      ],
      footer: const _AdminShellUserCard(),
      child: child,
    );
  }
}
