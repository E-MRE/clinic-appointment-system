part of 'admin_home_page.dart';

/// Arranges the four dashboard metrics in a responsive grid.
final class _AdminHomeMetricCards extends StatelessWidget {
  const _AdminHomeMetricCards({required this.clock, required this.summary});

  final Clock clock;
  final AdminDashboardSummary summary;

  double get _minWidthByGap =>
      AdminLayoutConstants.overviewMetricCardMinWidth + AppSizes.s16;

  String? get _todayCaption {
    if (summary.todayAppointmentCount ==
        AdminLayoutConstants.overviewEmptyCount) {
      return null;
    }

    return LocaleKeys.admin_overview_todayAppointmentsCaption.translate(
      args: [
        summary.distinctBranchCount.toString(),
        summary.distinctStaffCount.toString(),
      ],
    );
  }

  String? _pendingCaption(DateTime now) {
    final oldestPending = summary.oldestPendingCreatedAt;
    if (oldestPending == null) return null;

    return LocaleKeys.admin_overview_oldestPendingCaption.translate(
      args: [oldestPending.relativeLabel(now)],
    );
  }

  String? get _completedCaption {
    if (summary.todayAppointmentCount ==
        AdminLayoutConstants.overviewEmptyCount) {
      return null;
    }

    return LocaleKeys.admin_overview_completedCaption.translate(
      args: [
        summary.todayAppointmentCount.toString(),
        summary.completedCount.toString(),
      ],
    );
  }

  String? get _noShowCaption {
    if (summary.noShowCount == AdminLayoutConstants.overviewEmptyCount) {
      return null;
    }

    return LocaleKeys.admin_overview_noShowCaption.translate();
  }

  @override
  Widget build(BuildContext context) {
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
            _buildCard(
              cardWidth,
              title: LocaleKeys.admin_overview_todayAppointments.translate(),
              value: summary.todayAppointmentCount.toString(),
              caption: _todayCaption,
              tone: AdminMetricTone.primary,
            ),
            _buildCard(
              cardWidth,
              title: LocaleKeys.admin_overview_pendingAppointments.translate(),
              value: summary.pendingCount.toString(),
              caption: _pendingCaption(clock.now()),
              tone: AdminMetricTone.pending,
            ),
            _buildCard(
              cardWidth,
              title: LocaleKeys.admin_overview_completedToday.translate(),
              value: summary.completedCount.toString(),
              caption: _completedCaption,
              tone: AdminMetricTone.neutral,
            ),
            _buildCard(
              cardWidth,
              title: LocaleKeys.admin_overview_noShowToday.translate(),
              value: summary.noShowCount.toString(),
              caption: _noShowCaption,
              tone: AdminMetricTone.neutral,
            ),
          ],
        );
      },
    );
  }

  Widget _buildCard(
    double width, {
    required String title,
    required String value,
    required String? caption,
    required AdminMetricTone tone,
  }) {
    return SizedBox(
      width: width,
      child: _AdminHomeMetricCard(
        title: title,
        value: value,
        caption: caption,
        tone: tone,
      ),
    );
  }

  int _columnCount(double width) {
    final estimated = ((width + AppSizes.s16) / _minWidthByGap).floor();

    if (estimated < AdminLayoutConstants.overviewMinimumColumnCount) {
      return AdminLayoutConstants.overviewMinimumColumnCount;
    }
    if (estimated > AdminLayoutConstants.overviewMetricCardCount) {
      return AdminLayoutConstants.overviewMetricCardCount;
    }
    return estimated;
  }
}
