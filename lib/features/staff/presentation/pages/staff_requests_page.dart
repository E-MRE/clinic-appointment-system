import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/announced_semantics.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state_variant.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:clinic_appointment_system/core/widgets/state/empty_state.dart';
import 'package:clinic_appointment_system/core/widgets/state/error_state.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/cubit/appointment_action_state.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/appointment_error_code_localization.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/appointment_schedule_label.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/widgets/appointment_status_badge.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/appointment_approve_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_requests_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_requests_state.dart';
import 'package:clinic_appointment_system/features/staff/presentation/visitors/staff_appointment_actor_visitor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'staff_requests_view.dart';
part 'staff_requests_body.dart';
part 'staff_requests_failure.dart';
part 'staff_requests_empty.dart';
part 'staff_requests_list.dart';
part 'staff_request_row.dart';
part 'staff_request_approve_button.dart';
part 'staff_request_approve_progress.dart';
part 'staff_requests_approve.dart';

/// The signed-in staff member's pending appointment requests.
final class StaffRequestsPage extends StatelessWidget {
  /// Creates the routed requests page.
  const StaffRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;
    if (state is AuthSignedIn) {
      final user = state.user;
      final staff = user.staffProfile;
      if (staff != null) {
        return MultiBlocProvider(
          key: ValueKey<String>(staff.id),
          providers: [
            BlocProvider<StaffRequestsCubit>(
              create: (_) {
                return AppDependency.injector.get<StaffRequestsCubit>()
                  ..watch(staff.id);
              },
            ),
            BlocProvider<AppointmentApproveCubit>(
              create: (_) {
                return AppDependency.injector.get<AppointmentApproveCubit>();
              },
            ),
          ],
          child: const _StaffRequestsView(),
        );
      }
    }
    return const SizedBox.shrink();
  }
}
