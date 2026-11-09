part of 'staff_requests_page.dart';

/// One pending request: service, schedule, status and the approve button.
final class _StaffRequestRow extends StatelessWidget {
  const _StaffRequestRow({required this.request});

  final Appointment request;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      child: Row(
        spacing: AppSizes.s12,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSizes.s4,
              children: [
                AppText.cardTitle(request.serviceName),
                AppText.caption(request.dateTimeLabel, tone: TextTone.muted),
                AppointmentStatusBadge(status: request.status),
              ],
            ),
          ),
          _StaffRequestApproveButton(request: request),
        ],
      ),
    );
  }
}
