part of 'staff_requests_page.dart';

/// Approves its request; shows progress while that request is in flight and
/// stays disabled while any approval runs.
final class _StaffRequestApproveButton extends StatelessWidget {
  const _StaffRequestApproveButton({required this.request});

  final Appointment request;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentApproveCubit, AppointmentActionState>(
      builder: (context, state) {
        final String? runningId;
        if (state is AppointmentActionInProgress) {
          runningId = state.appointmentId;
        } else if (state is AppointmentActionSuccess) {
          runningId = null;
        } else if (state is AppointmentActionFailure) {
          runningId = null;
        } else {
          runningId = null;
        }
        return FilledButton(
          onPressed: runningId == null
              ? () => context.approveRequest(request)
              : null,
          child: runningId == request.id
              ? const _StaffRequestApproveProgress()
              : AppText.label(
                  LocaleKeys.staffRequests_approve.translate(),
                  tone: TextTone.onPrimary,
                ),
        );
      },
    );
  }
}
