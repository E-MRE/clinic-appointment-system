part of 'staff_requests_page.dart';

/// Actions row for the selected request: "Reddet…" and "Onayla".
final class _StaffRequestsDetailActions extends StatelessWidget {
  const _StaffRequestsDetailActions({required this.request});

  final Appointment request;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentApproveCubit, AppointmentActionState>(
      builder: (context, approveState) {
        return BlocBuilder<AppointmentRejectCubit, AppointmentActionState>(
          builder: (context, rejectState) {
            final isApproveRunning =
                approveState is AppointmentActionInProgress;
            final isRejectRunning = rejectState is AppointmentActionInProgress;
            final isDisabled = isApproveRunning || isRejectRunning;

            final isThisApproving =
                isApproveRunning && approveState.appointmentId == request.id;
            final isThisRejecting =
                isRejectRunning && rejectState.appointmentId == request.id;

            final errorColor = context.colorScheme.error;

            final Widget approveChild;
            if (isThisApproving) {
              approveChild = const _StaffRequestApproveProgress();
            } else {
              approveChild = Row(
                mainAxisSize: MainAxisSize.min,
                spacing: AppSizes.s8,
                children: [
                  const Icon(Icons.check, size: AppSizes.s20),
                  Text(LocaleKeys.staffRequests_approve.translate()),
                ],
              );
            }

            final Widget rejectChild;
            if (isThisRejecting) {
              rejectChild = const _StaffRequestApproveProgress();
            } else {
              rejectChild = Text(
                LocaleKeys.staffRequests_rejectAction.translate(),
              );
            }

            return Wrap(
              alignment: WrapAlignment.end,
              spacing: AppSizes.s12,
              runSpacing: AppSizes.s8,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: errorColor,
                    side: BorderSide(
                      color: isDisabled
                          ? context.colorScheme.outlineVariant
                          : errorColor,
                    ),
                  ),
                  onPressed: isDisabled ? null : () => _onReject(context),
                  child: rejectChild,
                ),
                FilledButton(
                  onPressed: isDisabled
                      ? null
                      : () => context.performAsStaff(
                          context.read<AppointmentApproveCubit>(),
                          request,
                        ),
                  child: approveChild,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _onReject(BuildContext context) async {
    final confirmation = await AppointmentReasonDialog(
      title: LocaleKeys.staffRequests_rejectTitle.translate(),
      subtitle:
          '${request.displayPatientName} · ${request.scheduleAndServiceLabel}',
      confirmLabel: LocaleKeys.staffRequests_reject.translate(),
    ).show(context);

    if (confirmation == null) return;
    if (!context.mounted) return;
    await context.performAsStaff(
      context.read<AppointmentRejectCubit>(),
      request,
      reason: confirmation.reason,
    );
  }
}
