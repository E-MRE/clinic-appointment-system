part of 'staff_requests_page.dart';

/// Two-column definition grid displaying date & time, service, duration & fee, and location.
final class _StaffRequestDetailGrid extends StatelessWidget {
  const _StaffRequestDetailGrid({
    required this.request,
    required this.workspace,
  });

  final Appointment request;
  final StaffWorkspace? workspace;

  @override
  Widget build(BuildContext context) {
    final String location;
    final currentWorkspace = workspace;
    if (currentWorkspace != null) {
      final branch = currentWorkspace.branch.name;
      final department = currentWorkspace.department.name;
      location = '$branch · $department';
    } else {
      location = LocaleKeys.common_notAvailable.translate();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s16,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppDefinitionRow(
                label: LocaleKeys.staffRequests_detail_dateTime.translate(),
                child: AppText.bodyStrong(request.scheduleRangeLabel),
              ),
            ),
            const EmptySize.s16Width(),
            Expanded(
              child: AppDefinitionRow(
                label: LocaleKeys.staffRequests_detail_service.translate(),
                child: AppText.bodyStrong(request.serviceName),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppDefinitionRow(
                label: LocaleKeys.staffRequests_detail_durationAndFee
                    .translate(),
                child: AppText.bodyStrong(request.durationAndFeeLabel),
              ),
            ),
            const EmptySize.s16Width(),
            Expanded(
              child: AppDefinitionRow(
                label: LocaleKeys.staffRequests_detail_location.translate(),
                child: AppText.bodyStrong(location),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
