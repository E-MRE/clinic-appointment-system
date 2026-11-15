part of 'admin_home_page.dart';

/// Displays the daily status distribution and its matching legend.
final class _AdminHomeStatusCard extends StatelessWidget {
  const _AdminHomeStatusCard({required this.summary});

  final AdminDashboardSummary summary;

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
              _buildEmptyState()
            else
              _AdminHomeStatusDistribution(summary: summary),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
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
}
