part of 'admin_appointment_row_actions.dart';

/// Optional-reason cancellation control for one approved administrator row.
final class _AdminAppointmentCancelAction extends StatelessWidget {
  const _AdminAppointmentCancelAction({required this.appointment});

  final Appointment appointment;

  Widget _label(AppointmentActionState state) {
    if (state is AppointmentActionInProgress) {
      return _AdminAppointmentActionProgress(
        label: LocaleKeys.staffAppointmentDialog_cancelAction.translate(),
      );
    }
    return AppText.label(
      LocaleKeys.staffAppointmentDialog_cancel.translate(),
      tone: TextTone.error,
    );
  }

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
          return OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colorScheme.error,
            ),
            onPressed: isBusy ? null : () => _cancel(context),
            child: _label(state),
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
