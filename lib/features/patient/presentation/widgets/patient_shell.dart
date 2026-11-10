import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_shell.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_user_card.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/patient_catalog_cubit.dart';
import 'package:clinic_appointment_system/features/patient/presentation/enums/patient_destination.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/patient_destination_navigation.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/patient_location_destination.dart';
import 'package:clinic_appointment_system/features/users/presentation/extensions/user_display_name.dart';
import 'package:clinic_appointment_system/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'patient_shell_user_card.dart';

/// Responsive patient navigation shared by all patient destinations.
/// Provides the clinic catalog once for every destination.
final class PatientShell extends StatelessWidget {
  /// Creates the patient shell around a routed page.
  const PatientShell({required this.child, super.key});

  /// The current patient destination.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final destination = GoRouterState.of(context).uri.path.patientDestination;
    return BlocProvider<PatientCatalogCubit>(
      create: (_) => AppDependency.injector.get<PatientCatalogCubit>()..watch(),
      child: AppNavigationShell(
        logo: Assets.images.brand.clinicLogo,
        selectedIndex: destination.index,
        onDestinationSelected: (index) {
          context.go(PatientDestination.values[index].route);
        },
        destinations: [
          for (final item in PatientDestination.values) item.destination,
        ],
        footer: const _PatientShellUserCard(),
        child: child,
      ),
    );
  }
}
