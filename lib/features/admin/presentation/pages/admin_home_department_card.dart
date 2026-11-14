part of 'admin_home_page.dart';

/// Lists today's department counts with proportional progress bars.
final class _AdminHomeDepartmentCard extends StatelessWidget {
  const _AdminHomeDepartmentCard({required this.summary});

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
              LocaleKeys.admin_overview_departmentBreakdown.translate(),
            ),
            const EmptySize.s16Height(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (summary.departmentRows.isEmpty) {
      return Center(
        child: AppText.body(
          LocaleKeys.admin_overview_emptyDepartments.translate(),
          tone: TextTone.muted,
          textAlign: TextAlign.center,
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AdminLayoutConstants.overviewBreakdownRowGap,
        children: [
          for (final row in summary.departmentRows)
            _AdminHomeDepartmentRow(row: row),
        ],
      ),
    );
  }
}
