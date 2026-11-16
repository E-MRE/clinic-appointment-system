part of 'admin_home_page.dart';

/// Arranges the status bar above the status legend.
final class _AdminHomeStatusDistribution extends StatelessWidget {
  /// Creates a status distribution from the dashboard summary.
  const _AdminHomeStatusDistribution({required this.summary});

  final AdminDashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AdminHomeStatusBar(summary: summary),
          const EmptySize.s16Height(),
          Expanded(child: _AdminHomeStatusLegend(summary: summary)),
        ],
      ),
    );
  }
}
