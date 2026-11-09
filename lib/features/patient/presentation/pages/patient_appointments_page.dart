import 'package:clinic_appointment_system/core/constants/patient_layout_constants.dart';
import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_choice.dart';
import 'package:clinic_appointment_system/core/widgets/data_table/app_data_table.dart';
import 'package:clinic_appointment_system/core/widgets/definition_row/app_definition_row.dart';
import 'package:clinic_appointment_system/core/widgets/form_dialog/app_form_dialog.dart';
import 'package:clinic_appointment_system/core/widgets/icon_tile/app_icon_tile.dart';
import 'package:clinic_appointment_system/core/widgets/list_tile/app_list_tile.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state_variant.dart';
import 'package:clinic_appointment_system/core/widgets/message_banner/app_message_banner.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:clinic_appointment_system/core/widgets/state/app_muted_message.dart';
import 'package:clinic_appointment_system/core/widgets/state/error_state.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_padding.dart';
import 'package:clinic_appointment_system/core/widgets/tab_bar/app_tab_bar.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/patient_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/cubit/appointment_action_state.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/appointment_error_code_localization.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/widgets/appointment_status_badge.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/patient_appointment_cancel_cubit.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/patient_appointments_cubit.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/patient_appointments_state.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/patient_appointments_tab_cubit.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/patient_catalog_cubit.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/patient_catalog_state.dart';
import 'package:clinic_appointment_system/features/patient/presentation/enums/patient_appointments_tab.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/patient_appointment_entry_presentation.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/patient_appointments_overview_presentation.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/patient_appointments_tab_selection.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/patient_department_summary_presentation.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_appointment_entry.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_appointments_overview.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_department_summary.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_preparation_note.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
import 'package:clinic_appointment_system/features/users/presentation/extensions/user_display_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'patient_appointments_cancel_confirm_dialog.dart';
part 'patient_appointments_cancel_error.dart';
part 'patient_appointments_cancel_request.dart';
part 'patient_appointments_content.dart';
part 'patient_appointments_date_tile.dart';
part 'patient_appointments_department_row.dart';
part 'patient_appointments_departments_card.dart';
part 'patient_appointments_details_dialog.dart';
part 'patient_appointments_dialog_actions.dart';
part 'patient_appointments_failure.dart';
part 'patient_appointments_list_card.dart';
part 'patient_appointments_next_actions.dart';
part 'patient_appointments_next_card.dart';
part 'patient_appointments_next_card_body.dart';
part 'patient_appointments_next_summary.dart';
part 'patient_appointments_note_row.dart';
part 'patient_appointments_notes_card.dart';
part 'patient_appointments_primary_column.dart';
part 'patient_appointments_secondary_column.dart';
part 'patient_appointments_service_cell.dart';
part 'patient_appointments_table.dart';
part 'patient_appointments_tabs.dart';
part 'patient_appointments_view.dart';

/// The signed-in patient's appointments, preparation notes and departments.
final class PatientAppointmentsPage extends StatelessWidget {
  /// Creates the routed appointments page.
  const PatientAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;
    if (state case AuthSignedIn(:final user)) {
      return MultiBlocProvider(
        key: ValueKey<String>(user.id),
        providers: [
          BlocProvider<PatientAppointmentsCubit>(
            create: (_) {
              return AppDependency.injector.get<PatientAppointmentsCubit>()
                ..watch(user.id);
            },
          ),
          BlocProvider<PatientAppointmentsTabCubit>(
            create: (_) {
              return AppDependency.injector.get<PatientAppointmentsTabCubit>();
            },
          ),
        ],
        child: _PatientAppointmentsView(user: user),
      );
    }
    return const SizedBox.shrink();
  }
}
