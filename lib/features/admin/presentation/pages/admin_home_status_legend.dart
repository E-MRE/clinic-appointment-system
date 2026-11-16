part of 'admin_home_page.dart';

/// Shows each appointment status with its color, label and count.
final class _AdminHomeStatusLegend extends StatelessWidget {
  /// Creates a status legend from the dashboard summary.
  const _AdminHomeStatusLegend({required this.summary});

  final AdminDashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AdminLayoutConstants.overviewBreakdownRowGap,
      children: [
        for (final row in summary.statusCounts)
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
      ],
    );
  }
}
