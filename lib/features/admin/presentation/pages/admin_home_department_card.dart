part of 'admin_home_page.dart';

/// Lists today's department counts with proportional progress bars.
final class _AdminHomeDepartmentCard extends StatelessWidget {
  const _AdminHomeDepartmentCard({required this.summary});

  final AdminDashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final rows = summary.departmentRows;
    return SizedBox(
      height: AdminLayoutConstants.overviewBreakdownCardHeight,
      child: AppSurface(
        padding: AppSurfacePadding.spacious,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppText.cardTitle(
              LocaleKeys.admin_overview_departmentBreakdown.translate(),
            ),
            const EmptySize.s16Height(),
            Expanded(
              child: rows.isEmpty
                  ? Center(
                      child: AppText.body(
                        LocaleKeys.admin_overview_emptyDepartments.translate(),
                        tone: TextTone.muted,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: AdminLayoutConstants.overviewBreakdownRowGap,
                        children: [
                          for (final row in rows)
                            _AdminHomeDepartmentRow(row: row),
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
