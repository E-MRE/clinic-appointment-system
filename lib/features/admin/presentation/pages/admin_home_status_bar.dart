part of 'admin_home_page.dart';

/// Shows proportional colored segments for each appointment status.
final class _AdminHomeStatusBar extends StatelessWidget {
  /// Creates a status bar from the dashboard summary.
  const _AdminHomeStatusBar({required this.summary});

  final AdminDashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AdminLayoutConstants.overviewStackedBarHeight,
      child: ClipRRect(
        borderRadius: const AppRadius.full(),
        child: Row(
          children: [
            for (final row in summary.statusCounts)
              Expanded(
                flex: row.count,
                child: ColoredBox(color: row.status.color(context)),
              ),
          ],
        ),
      ),
    );
  }
}
