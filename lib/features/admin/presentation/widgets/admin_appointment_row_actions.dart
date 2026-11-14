import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/features/admin/presentation/extensions/admin_appointment_action_context.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/cubit/appointment_action_state.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/appointment_action_feedback.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/widgets/appointment_reason_dialog.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/appointment_approve_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/appointment_reject_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/appointment_staff_cancel_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'admin_appointment_pending_actions.dart';
part 'admin_appointment_pending_buttons.dart';
part 'admin_appointment_pending_button_row.dart';
part 'admin_appointment_cancel_action.dart';
part 'admin_appointment_action_progress.dart';

/// Owns the lifecycle Cubits and controls for one administrator appointment row.
final class AdminAppointmentRowActions extends StatelessWidget {
  /// Creates actions from the domain-checked [offeredActions].
  const AdminAppointmentRowActions({
    required this.appointment,
    required this.offeredActions,
    super.key,
  });

  /// Appointment changed by an offered action.
  final Appointment appointment;

  /// Actions accepted by the row presentation's domain dry-run.
  final List<AppointmentAction> offeredActions;

  bool get _hasPendingActions =>
      offeredActions.contains(AppointmentAction.approve) &&
      offeredActions.contains(AppointmentAction.reject);

  bool get _hasCancelAction =>
      offeredActions.contains(AppointmentAction.cancelByStaff);

  @override
  Widget build(BuildContext context) {
    if (_hasPendingActions) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<AppointmentApproveCubit>(
            create: (_) =>
                AppDependency.injector.get<AppointmentApproveCubit>(),
          ),
          BlocProvider<AppointmentRejectCubit>(
            create: (_) => AppDependency.injector.get<AppointmentRejectCubit>(),
          ),
        ],
        child: _AdminAppointmentPendingActions(appointment: appointment),
      );
    }
    if (_hasCancelAction) {
      return BlocProvider<AppointmentStaffCancelCubit>(
        create: (_) =>
            AppDependency.injector.get<AppointmentStaffCancelCubit>(),
        child: _AdminAppointmentCancelAction(appointment: appointment),
      );
    }
    return const SizedBox.shrink();
  }
}
