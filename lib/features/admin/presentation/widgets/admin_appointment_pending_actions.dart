part of 'admin_appointment_row_actions.dart';

/// Approve and reject controls for one pending administrator row.
final class _AdminAppointmentPendingActions extends StatelessWidget {
  const _AdminAppointmentPendingActions({required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppointmentApproveCubit, AppointmentActionState>(
          listener: (context, state) {
            context.showAppointmentActionFeedback(
              state,
              successMessage: LocaleKeys.staffRequests_approved.translate(),
            );
          },
        ),
        BlocListener<AppointmentRejectCubit, AppointmentActionState>(
          listener: (context, state) {
            context.showAppointmentActionFeedback(
              state,
              successMessage: LocaleKeys.staffRequests_rejected.translate(),
            );
          },
        ),
      ],
      child: BlocBuilder<AppointmentApproveCubit, AppointmentActionState>(
        builder: (context, approveState) {
          return BlocBuilder<AppointmentRejectCubit, AppointmentActionState>(
            builder: (context, rejectState) {
              final isBusy =
                  approveState is AppointmentActionInProgress ||
                  rejectState is AppointmentActionInProgress;
              final Widget approveLabel;
              if (approveState is AppointmentActionInProgress) {
                approveLabel = _AdminAppointmentActionProgress(
                  label: LocaleKeys.staffRequests_approving.translate(),
                );
              } else {
                approveLabel = AppText.label(
                  LocaleKeys.staffRequests_approve.translate(),
                  tone: TextTone.onPrimary,
                );
              }
              final Widget rejectLabel;
              if (rejectState is AppointmentActionInProgress) {
                rejectLabel = _AdminAppointmentActionProgress(
                  label: LocaleKeys.staffRequests_rejectAction.translate(),
                );
              } else {
                rejectLabel = AppText.label(
                  LocaleKeys.staffRequests_reject.translate(),
                );
              }

              return Wrap(
                spacing: AppSizes.s8,
                runSpacing: AppSizes.s8,
                children: [
                  FilledButton(
                    onPressed: isBusy
                        ? null
                        : () {
                            context.performAsAdmin(
                              context.read<AppointmentApproveCubit>(),
                              appointment,
                            );
                          },
                    child: approveLabel,
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.colorScheme.error,
                      side: BorderSide(
                        color: isBusy
                            ? context.colorScheme.outlineVariant
                            : context.colorScheme.error,
                      ),
                    ),
                    onPressed: isBusy ? null : () => _reject(context),
                    child: rejectLabel,
                  ),
                ],
              );
            },
          );
        },
      ),
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
