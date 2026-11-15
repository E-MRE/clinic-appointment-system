part of 'admin_home_page.dart';

/// Shows the department rows or the department empty state.
final class _AdminHomeDepartmentCardBody extends StatelessWidget {
  /// Creates the department card body from the dashboard summary.
  const _AdminHomeDepartmentCardBody({required this.summary});

  final AdminDashboardSummary summary;

  @override
  Widget build(BuildContext context) {
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
