import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:clinic_appointment_system/core/widgets/state/empty_state.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/staff_availability_cubit.dart';
import 'package:clinic_appointment_system/features/availability/presentation/extensions/availability_header_presentation.dart';
import 'package:clinic_appointment_system/features/availability/presentation/widgets/availability_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'availability_staff_header.dart';
part 'availability_not_found.dart';

/// Signed-in staff entry point for weekly and one-off availability.
final class AvailabilityPage extends StatelessWidget {
  /// Creates the routed availability page.
  const AvailabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;
    if (state case AuthSignedIn(:final user)) {
      final staff = user.staffProfile;
      if (staff != null) {
        return AvailabilityBody(
          key: ValueKey((staff.id, staff.branchId, staff.serviceIds)),
          staff: staff,
          header: const _AvailabilityStaffHeader(),
        );
      }
    }
    return const _AvailabilityNotFound();
  }
}
