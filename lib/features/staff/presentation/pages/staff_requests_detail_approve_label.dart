part of 'staff_requests_page.dart';

/// The approve action label or progress indicator for the selected request.
final class _StaffRequestsDetailApproveLabel extends StatelessWidget {
  const _StaffRequestsDetailApproveLabel({
    required this.request,
    required this.approveState,
  });

  final Appointment request;
  final AppointmentActionState approveState;

  @override
  Widget build(BuildContext context) {
    final currentApproveState = approveState;
    if (currentApproveState is AppointmentActionInProgress) {
      if (currentApproveState.appointmentId == request.id) {
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
}
