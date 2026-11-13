part of 'staff_requests_page.dart';

/// Actions row for the selected request.
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

            return Wrap(
              alignment: WrapAlignment.end,
              spacing: AppSizes.s12,
              runSpacing: AppSizes.s8,
              children: [
                _buildOutlinedButton(context, rejectState, isDisabled),
                _buildFilledButton(context, approveState, isDisabled),
              ],
            );
          },
        );
      },
    );
  }

  FilledButton _buildFilledButton(
    BuildContext context,
    AppointmentActionState approveState,
    bool isDisabled,
  ) {
    return FilledButton(
      onPressed: isDisabled
          ? null
          : () => context.performAsStaff(
              context.read<AppointmentApproveCubit>(),
              request,
            ),
      child: _buildApprove(approveState),
    );
  }

  OutlinedButton _buildOutlinedButton(
    BuildContext context,
    AppointmentActionState rejectState,
    bool isDisabled,
  ) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: context.colorScheme.error,
        side: BorderSide(
          color: isDisabled
              ? context.colorScheme.outlineVariant
              : context.colorScheme.error,
        ),
      ),
      onPressed: isDisabled ? null : () => _onReject(context),
      child: _buildReject(rejectState),
    );
  }

  Widget _buildReject(AppointmentActionState rejectState) {
    if (rejectState is AppointmentActionInProgress) {
      if (rejectState.appointmentId == request.id) {
        return const _StaffRequestApproveProgress();
      }
    }

    return Text(LocaleKeys.staffRequests_rejectAction.translate());
  }

  Widget _buildApprove(AppointmentActionState approveState) {
    if (approveState is AppointmentActionInProgress) {
      if (approveState.appointmentId == request.id) {
        return const _StaffRequestApproveProgress();
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSizes.s8,
      children: [
        const Icon(Icons.check, size: AppSizes.s20),
        Text(LocaleKeys.staffRequests_approve.translate()),
      ],
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
