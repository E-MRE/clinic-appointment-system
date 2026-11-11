import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart'
    hide AppointmentStatus;
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/definition_row/app_definition_row.dart';
import 'package:clinic_appointment_system/core/widgets/message_banner/app_message_banner.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/cubit/appointment_action_state.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/appointment_error_code_localization.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/widgets/appointment_reason_dialog.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/widgets/appointment_status_badge.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/appointment_approve_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/appointment_complete_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/appointment_no_show_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/appointment_reject_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/appointment_staff_cancel_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_workspace_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_workspace_state.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_appointment_action_context.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_appointment_presentation.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_appointment_action_offer.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_appointment_action_offers.dart';
import 'package:clinic_appointment_system/features/staff/presentation/widgets/staff_appointment_detail_grid.dart';
import 'package:clinic_appointment_system/features/staff/presentation/widgets/staff_patient_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'staff_appointment_dialog_actions.dart';
part 'staff_appointment_dialog_action_button.dart';
part 'staff_appointment_dialog_content.dart';
part 'staff_appointment_dialog_error.dart';
part 'staff_appointment_dialog_progress.dart';

/// Displays appointment details and the lifecycle actions currently allowed to staff.
final class StaffAppointmentDialog extends StatelessWidget {
  const StaffAppointmentDialog._({required this.appointment});

  /// Appointment snapshot to display and act on.
  final Appointment appointment;

  /// Opens [appointment] with screen-owned lifecycle cubits.
  static Future<void> show(
    BuildContext context,
    Appointment appointment,
  ) async {
    final auth = context.read<AuthCubit>();
    final workspace = context.read<StaffWorkspaceCubit>();
    await showDialog<void>(
      context: context,
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>.value(value: auth),
            BlocProvider<StaffWorkspaceCubit>.value(value: workspace),
            BlocProvider<AppointmentApproveCubit>(
              create: (_) =>
                  AppDependency.injector.get<AppointmentApproveCubit>(),
            ),
            BlocProvider<AppointmentRejectCubit>(
              create: (_) =>
                  AppDependency.injector.get<AppointmentRejectCubit>(),
            ),
            BlocProvider<AppointmentCompleteCubit>(
              create: (_) =>
                  AppDependency.injector.get<AppointmentCompleteCubit>(),
            ),
            BlocProvider<AppointmentNoShowCubit>(
              create: (_) =>
                  AppDependency.injector.get<AppointmentNoShowCubit>(),
            ),
            BlocProvider<AppointmentStaffCancelCubit>(
              create: (_) =>
                  AppDependency.injector.get<AppointmentStaffCancelCubit>(),
            ),
          ],
          child: StaffAppointmentDialog._(appointment: appointment),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppointmentApproveCubit, AppointmentActionState>(
          listener: (context, state) => _showFeedback(
            context,
            state,
            LocaleKeys.staffRequests_approved.translate(),
          ),
        ),
        BlocListener<AppointmentRejectCubit, AppointmentActionState>(
          listener: (context, state) => _showFeedback(
            context,
            state,
            LocaleKeys.staffRequests_rejected.translate(),
          ),
        ),
        BlocListener<AppointmentCompleteCubit, AppointmentActionState>(
          listener: (context, state) => _showFeedback(
            context,
            state,
            LocaleKeys.staffAppointmentDialog_completed.translate(),
          ),
        ),
        BlocListener<AppointmentNoShowCubit, AppointmentActionState>(
          listener: (context, state) => _showFeedback(
            context,
            state,
            LocaleKeys.staffAppointmentDialog_noShowMarked.translate(),
          ),
        ),
        BlocListener<AppointmentStaffCancelCubit, AppointmentActionState>(
          listener: (context, state) => _showFeedback(
            context,
            state,
            LocaleKeys.staffAppointmentDialog_cancelled.translate(),
          ),
        ),
      ],
      child: AlertDialog(
        content: _StaffAppointmentDialogContent(appointment: appointment),
      ),
    );
  }

  void _showFeedback(
    BuildContext context,
    AppointmentActionState state,
    String successMessage,
  ) {
    if (state is! AppointmentActionSuccess) return;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(SnackBar(content: Text(successMessage)));
  }
}
