import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/core/widgets/announced_semantics.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/avatar/app_avatar.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_choice.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state_variant.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:clinic_appointment_system/core/widgets/state/empty_state.dart';
import 'package:clinic_appointment_system/core/widgets/state/error_state.dart';
import 'package:clinic_appointment_system/core/widgets/status_badge/status_badge.dart';
import 'package:clinic_appointment_system/core/widgets/status_badge/status_badge_variant.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_padding.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_variant.dart';
import 'package:clinic_appointment_system/core/widgets/tab_bar/app_tab_bar.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/cubit/appointment_action_state.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/appointment_action_feedback.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/appointment_error_code_localization.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/widgets/appointment_reason_dialog.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/appointment_approve_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/appointment_reject_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_appointments_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_appointments_state.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_request_selection_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_workspace_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_workspace_state.dart';
import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_request_sort.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_appointment_action_context.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_appointment_presentation.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_request_sort_ordering.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_requests_header_subtitle.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_patient_history.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_rule_check_factory.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_workspace.dart';
import 'package:clinic_appointment_system/features/staff/presentation/widgets/staff_appointment_detail_grid.dart';
import 'package:clinic_appointment_system/features/staff/presentation/widgets/staff_patient_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'staff_request_approve_progress.dart';
part 'staff_request_card.dart';
part 'staff_requests_body.dart';
part 'staff_requests_desktop_layout.dart';
part 'staff_requests_detail_actions.dart';
part 'staff_requests_detail_panel.dart';
part 'staff_requests_detail_patient_history.dart';
part 'staff_requests_detail_rule_checks.dart';
part 'staff_requests_empty.dart';
part 'staff_requests_failure.dart';
part 'staff_requests_header.dart';
part 'staff_requests_list.dart';
part 'staff_requests_narrow_layout.dart';
part 'staff_requests_sort_toggle.dart';
part 'staff_requests_view.dart';

/// The signed-in staff member's pending appointment requests.
final class StaffRequestsPage extends StatelessWidget {
  /// Creates the routed requests page.
  const StaffRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppointmentApproveCubit>(
          create: (_) => AppDependency.injector.get<AppointmentApproveCubit>(),
        ),
        BlocProvider<AppointmentRejectCubit>(
          create: (_) => AppDependency.injector.get<AppointmentRejectCubit>(),
        ),
        BlocProvider<StaffRequestSelectionCubit>(
          create: (context) {
            final cubit = StaffRequestSelectionCubit();
            final pending = context
                .read<StaffAppointmentsCubit>()
                .state
                .pendingRequests;
            cubit.syncRequests(pending);
            return cubit;
          },
        ),
      ],
      child: const _StaffRequestsView(),
    );
  }
}
