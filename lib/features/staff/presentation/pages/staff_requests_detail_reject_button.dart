part of 'staff_requests_page.dart';

/// An outlined action for rejecting the selected appointment request.
final class _StaffRequestsDetailRejectButton extends StatelessWidget {
  const _StaffRequestsDetailRejectButton({
    required this.request,
    required this.rejectState,
    required this.isDisabled,
  });

  final Appointment request;
  final AppointmentActionState rejectState;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final errorColor = context.colorScheme.error;
    final outlineColor = context.colorScheme.outlineVariant;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: errorColor,
        side: BorderSide(color: isDisabled ? outlineColor : errorColor),
      ),
      onPressed: isDisabled ? null : () => _onReject(context),
      child: _buildReject(),
    );
  }

  Widget _buildReject() {
    final currentRejectState = rejectState;
    if (currentRejectState is AppointmentActionInProgress) {
      if (currentRejectState.appointmentId == request.id) {
        return const _StaffRequestApproveProgress();
      }
    }

    return Text(LocaleKeys.staffRequests_rejectAction.translate());
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
