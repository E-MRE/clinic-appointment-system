part of 'admin_home_page.dart';

/// Arranges the four dashboard metrics in a responsive grid.
final class _AdminHomeMetricCards extends StatelessWidget {
  const _AdminHomeMetricCards({required this.clock, required this.summary});

  final Clock clock;
  final AdminDashboardSummary summary;

  int _columnCount(double width) {
    const gap = AppSizes.s16;
    final estimated =
        ((width + gap) /
                (AdminLayoutConstants.overviewMetricCardMinWidth + gap))
            .floor();
    if (estimated < AdminLayoutConstants.overviewMinimumColumnCount) {
      return AdminLayoutConstants.overviewMinimumColumnCount;
    }
    if (estimated > AdminLayoutConstants.overviewMetricCardCount) {
      return AdminLayoutConstants.overviewMetricCardCount;
    }
    return estimated;
  }

  @override
  Widget build(BuildContext context) {
    final now = clock.now();
    final oldestPending = summary.oldestPendingCreatedAt;
    final todayCaption =
        summary.todayAppointmentCount == AdminLayoutConstants.overviewEmptyCount
        ? null
        : LocaleKeys.admin_overview_todayAppointmentsCaption.translate(
            args: [
              summary.distinctBranchCount.toString(),
              summary.distinctStaffCount.toString(),
            ],
          );
    final pendingCaption = oldestPending == null
        ? null
        : LocaleKeys.admin_overview_oldestPendingCaption.translate(
            args: [oldestPending.relativeLabel(now)],
          );
    final completedCaption =
        summary.todayAppointmentCount == AdminLayoutConstants.overviewEmptyCount
        ? null
        : LocaleKeys.admin_overview_completedCaption.translate(
            args: [
              summary.todayAppointmentCount.toString(),
              summary.completedCount.toString(),
            ],
          );
    final noShowCaption =
        summary.noShowCount == AdminLayoutConstants.overviewEmptyCount
        ? null
        : LocaleKeys.admin_overview_noShowCaption.translate();
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = _columnCount(constraints.maxWidth);
        final columnGaps =
            columns - AdminLayoutConstants.overviewMinimumColumnCount;
        final cardWidth =
            (constraints.maxWidth - AppSizes.s16 * columnGaps) / columns;
        return Wrap(
          spacing: AppSizes.s16,
          runSpacing: AppSizes.s16,
          children: [
            SizedBox(
              width: cardWidth,
              child: _AdminHomeMetricCard(
                title: LocaleKeys.admin_overview_todayAppointments.translate(),
                value: summary.todayAppointmentCount.toString(),
                caption: todayCaption,
                tone: AdminMetricTone.primary,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _AdminHomeMetricCard(
                title: LocaleKeys.admin_overview_pendingAppointments
                    .translate(),
                value: summary.pendingCount.toString(),
                caption: pendingCaption,
                tone: AdminMetricTone.pending,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _AdminHomeMetricCard(
                title: LocaleKeys.admin_overview_completedToday.translate(),
                value: summary.completedCount.toString(),
                caption: completedCaption,
                tone: AdminMetricTone.neutral,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _AdminHomeMetricCard(
                title: LocaleKeys.admin_overview_noShowToday.translate(),
                value: summary.noShowCount.toString(),
                caption: noShowCaption,
                tone: AdminMetricTone.neutral,
              ),
            ),
          ],
        );
      },
    );
  }
}
