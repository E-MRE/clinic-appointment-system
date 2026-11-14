part of 'admin_home_page.dart';

/// Lists today's staff counts with their department and branch context.
final class _AdminHomeStaffCard extends StatelessWidget {
  const _AdminHomeStaffCard({required this.summary});

  final AdminDashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final rows = summary.staffRows;
    return SizedBox(
      height: AdminLayoutConstants.overviewBreakdownCardHeight,
      child: AppSurface(
        padding: AppSurfacePadding.spacious,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppText.cardTitle(
              LocaleKeys.admin_overview_staffBreakdown.translate(),
            ),
            const EmptySize.s16Height(),
            Expanded(
              child: rows.isEmpty
                  ? Center(
                      child: AppText.body(
                        LocaleKeys.admin_overview_emptyStaff.translate(),
                        tone: TextTone.muted,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: AppSizes.s8,
                        children: [
                          for (final row in rows) _AdminHomeStaffRow(row: row),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
