part of 'staff_requests_page.dart';

/// Summarises prior completed visits of the requesting patient.
final class _StaffRequestDetailPatientHistory extends StatelessWidget {
  const _StaffRequestDetailPatientHistory({required this.history});

  final StaffPatientHistory history;

  @override
  Widget build(BuildContext context) {
    final formatter = AppDependency.injector
        .get<StaffPatientHistoryFormatter>();
    final completedLabel = formatter.completedLabel(history);
    final lastVisit = formatter.lastVisitLabel(history);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s12,
      children: [
        AppText.sectionTitle(
          LocaleKeys.staffRequests_detail_historySection.translate(),
        ),
        Row(
          spacing: AppSizes.s12,
          children: [
            StatusBadge(
              label: completedLabel,
              variant: StatusBadgeVariant.completed,
            ),
            if (lastVisit != null)
              AppText.caption(lastVisit, tone: TextTone.muted),
          ],
        ),
      ],
    );
  }
}
