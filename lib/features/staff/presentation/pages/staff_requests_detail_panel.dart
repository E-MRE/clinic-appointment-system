part of 'staff_requests_page.dart';

/// Placeholder detail panel for the selected request.
///
/// Replaced by the complete review panel in the next lane.
final class _StaffRequestsDetailPanel extends StatelessWidget {
  const _StaffRequestsDetailPanel({required this.request});

  final Appointment request;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      padding: AppSurfacePadding.comfortable,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: AppSizes.s16,
        children: [
          AppText.cardTitle(request.displayPatientName),
          _StaffRequestApproveButton(request: request),
        ],
      ),
    );
  }
}
