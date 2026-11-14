part of 'admin_home_page.dart';

/// Arranges the four dashboard metrics in a responsive grid.
final class _AdminHomeMetricCards extends StatelessWidget {
  const _AdminHomeMetricCards({required this.clock, required this.summary});

  final Clock clock;
  final AdminDashboardSummary summary;

  ({String? today, String? pending, String? completed, String? noShow})
  _captions(DateTime now) {
    final todayCaption =
        summary.todayAppointmentCount == AdminLayoutConstants.overviewEmptyCount
        ? null
        : LocaleKeys.admin_overview_todayAppointmentsCaption.translate(
            args: [
              summary.distinctBranchCount.toString(),
              summary.distinctStaffCount.toString(),
            ],
          );
    final oldestPending = summary.oldestPendingCreatedAt;
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

    return (
      today: todayCaption,
      pending: pendingCaption,
      completed: completedCaption,
      noShow: noShowCaption,
    );
  }

  List<(String, String, String?, AdminMetricTone)> _metricValues(
    ({String? today, String? pending, String? completed, String? noShow})
    captions,
  ) {
    return [
      (
        LocaleKeys.admin_overview_todayAppointments.translate(),
        summary.todayAppointmentCount.toString(),
        captions.today,
        AdminMetricTone.primary,
      ),
      (
        LocaleKeys.admin_overview_pendingAppointments.translate(),
        summary.pendingCount.toString(),
        captions.pending,
        AdminMetricTone.pending,
      ),
      (
        LocaleKeys.admin_overview_completedToday.translate(),
        summary.completedCount.toString(),
        captions.completed,
        AdminMetricTone.neutral,
      ),
      (
        LocaleKeys.admin_overview_noShowToday.translate(),
        summary.noShowCount.toString(),
        captions.noShow,
        AdminMetricTone.neutral,
      ),
    ];
  }

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
    final captions = _captions(clock.now());
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
            for (final metric in _metricValues(captions))
              SizedBox(
                width: cardWidth,
                child: _AdminHomeMetricCard(
                  title: metric.$1,
                  value: metric.$2,
                  caption: metric.$3,
                  tone: metric.$4,
                ),
              ),
          ],
        );
      },
    );
  }
}
