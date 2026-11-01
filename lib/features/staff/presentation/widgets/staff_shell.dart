import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_shell.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_user_card.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_destination.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_destination_navigation.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_location_destination.dart';
import 'package:clinic_appointment_system/features/staff/presentation/visitors/staff_role_subtitle_visitor.dart';
import 'package:clinic_appointment_system/features/users/presentation/extensions/staff_initials.dart';
import 'package:clinic_appointment_system/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'staff_shell_user_card.dart';

/// Responsive staff navigation shared by all staff destinations.
final class StaffShell extends StatelessWidget {
  /// Creates the staff shell around a routed page.
  const StaffShell({required this.child, super.key});

  /// The current staff destination.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final destination = GoRouterState.of(context).uri.path.staffDestination;
    return AppNavigationShell(
      logo: Assets.images.brand.clinicLogo,
      selectedIndex: destination.index,
      onDestinationSelected: (index) {
        context.go(StaffDestination.values[index].route);
      },
      destinations: [
        for (final item in StaffDestination.values) item.destination,
      ],
      footer: const _StaffShellUserCard(),
      child: child,
    );
  }
}
