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
                _StaffRequestsDetailRejectButton(
                  request: request,
                  rejectState: rejectState,
                  isDisabled: isDisabled,
                ),
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
      child: _StaffRequestsDetailApproveLabel(
        request: request,
        approveState: approveState,
      ),
    );
  }
}
