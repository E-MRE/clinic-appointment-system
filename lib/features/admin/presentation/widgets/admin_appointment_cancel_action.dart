part of 'admin_appointment_row_actions.dart';

/// Optional-reason cancellation control for one approved administrator row.
final class _AdminAppointmentCancelAction extends StatelessWidget {
  const _AdminAppointmentCancelAction({required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentStaffCancelCubit, AppointmentActionState>(
      listener: (context, state) {
        context.showAppointmentActionFeedback(
          state,
          successMessage: LocaleKeys.staffAppointmentDialog_cancelled
              .translate(),
        );
      },
      child: BlocBuilder<AppointmentStaffCancelCubit, AppointmentActionState>(
        builder: (context, state) {
          final isBusy = state is AppointmentActionInProgress;
          final Widget label;
          if (isBusy) {
            label = _AdminAppointmentActionProgress(
              label: LocaleKeys.staffAppointmentDialog_cancelAction.translate(),
            );
          } else {
            label = AppText.label(
              LocaleKeys.staffAppointmentDialog_cancel.translate(),
              tone: TextTone.error,
            );
          }
          return OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colorScheme.error,
            ),
            onPressed: isBusy ? null : () => _cancel(context),
            child: label,
          );
        },
      ),
    );
  }

  Future<void> _cancel(BuildContext context) async {
    final confirmation = await AppointmentReasonDialog(
      title: LocaleKeys.staffAppointmentDialog_cancelTitle.translate(),
      subtitle: '${appointment.patientName} · ${appointment.serviceName}',
      confirmLabel: LocaleKeys.staffAppointmentDialog_cancel.translate(),
    ).show(context);
    if (confirmation == null || !context.mounted) return;
    await context.performAsAdmin(
      context.read<AppointmentStaffCancelCubit>(),
      appointment,
      reason: confirmation.reason,
    );
  }
}
