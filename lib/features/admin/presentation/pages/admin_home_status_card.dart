part of 'admin_home_page.dart';

/// Displays the daily status distribution and its matching legend.
final class _AdminHomeStatusCard extends StatelessWidget {
  const _AdminHomeStatusCard({required this.summary});

  final AdminDashboardSummary summary;

  Widget get _emptyState {
    return Expanded(
      child: Center(
        child: AppText.body(
          LocaleKeys.admin_overview_emptyStatus.translate(),
          tone: TextTone.muted,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _statusBar(
    BuildContext context,
    List<AdminDashboardStatusCount> statusCounts,
  ) {
    return SizedBox(
      height: AdminLayoutConstants.overviewStackedBarHeight,
      child: ClipRRect(
        borderRadius: const AppRadius.full(),
        child: Row(
          children: [
            for (final row in statusCounts)
              Expanded(
                flex: row.count,
                child: ColoredBox(color: row.status.color(context)),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _legend(
    BuildContext context,
    List<AdminDashboardStatusCount> statusCounts,
  ) {
    return [
      for (final row in statusCounts)
        Row(
          spacing: AppSizes.s8,
          children: [
            Container(
              width: AdminLayoutConstants.overviewLegendDotSize,
              height: AdminLayoutConstants.overviewLegendDotSize,
              decoration: BoxDecoration(
                color: row.status.color(context),
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: AppText.body(
                row.status.label,
                tone: TextTone.muted,
                maxLines: AdminLayoutConstants.overviewMinimumColumnCount,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AppText.bodyStrong(row.count.toString()),
          ],
        ),
    ];
  }

  Widget _distribution(
    BuildContext context,
    List<AdminDashboardStatusCount> statusCounts,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _statusBar(context, statusCounts),
          const EmptySize.s16Height(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AdminLayoutConstants.overviewBreakdownRowGap,
              children: _legend(context, statusCounts),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AdminLayoutConstants.overviewBreakdownCardHeight,
      child: AppSurface(
        padding: AppSurfacePadding.spacious,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppText.cardTitle(
              LocaleKeys.admin_overview_statusBreakdown.translate(),
            ),
            const EmptySize.s16Height(),
            if (summary.statusCounts.isEmpty)
              _emptyState
            else
              _distribution(context, summary.statusCounts),
          ],
        ),
      ),
    );
  }
}
