part of 'admin_appointment_row_actions.dart';

/// Renders enabled or in-progress controls for the pending appointment.
final class _AdminAppointmentPendingButtonRow extends StatelessWidget {
  const _AdminAppointmentPendingButtonRow({
    required this.appointment,
    required this.approveState,
    required this.rejectState,
  });

  final Appointment appointment;
  final AppointmentActionState approveState;
  final AppointmentActionState rejectState;

  bool get _isBusy =>
      approveState is AppointmentActionInProgress ||
      rejectState is AppointmentActionInProgress;

  Widget _approveLabel() {
    if (approveState is AppointmentActionInProgress) {
      return _AdminAppointmentActionProgress(
        label: LocaleKeys.staffRequests_approving.translate(),
      );
    }
    return AppText.label(
      LocaleKeys.staffRequests_approve.translate(),
      tone: TextTone.onPrimary,
    );
  }

  Widget _rejectLabel() {
    if (rejectState is AppointmentActionInProgress) {
      return _AdminAppointmentActionProgress(
        label: LocaleKeys.staffRequests_rejectAction.translate(),
      );
    }
    return AppText.label(LocaleKeys.staffRequests_reject.translate());
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.s8,
      runSpacing: AppSizes.s8,
      children: [
        FilledButton(
          onPressed: _isBusy
              ? null
              : () {
                  context.performAsAdmin(
                    context.read<AppointmentApproveCubit>(),
                    appointment,
                  );
                },
          child: _approveLabel(),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: context.colorScheme.error,
            side: BorderSide(
              color: _isBusy
                  ? context.colorScheme.outlineVariant
                  : context.colorScheme.error,
            ),
          ),
          onPressed: _isBusy ? null : () => _reject(context),
          child: _rejectLabel(),
        ),
      ],
    );
  }

  Future<void> _reject(BuildContext context) async {
    final confirmation = await AppointmentReasonDialog(
      title: LocaleKeys.staffRequests_rejectTitle.translate(),
      subtitle: '${appointment.patientName} · ${appointment.serviceName}',
      confirmLabel: LocaleKeys.staffRequests_reject.translate(),
    ).show(context);
    if (confirmation == null || !context.mounted) return;
    await context.performAsAdmin(
      context.read<AppointmentRejectCubit>(),
      appointment,
      reason: confirmation.reason,
    );
  }
}
