part of 'admin_home_page.dart';

/// Shows the staff rows or the staff empty state.
final class _AdminHomeStaffCardBody extends StatelessWidget {
  /// Creates the staff card body from the dashboard summary.
  const _AdminHomeStaffCardBody({required this.summary});

  final AdminDashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    if (summary.staffRows.isEmpty) {
      return Center(
        child: AppText.body(
          LocaleKeys.admin_overview_emptyStaff.translate(),
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
          for (final row in summary.staffRows) _AdminHomeStaffRow(row: row),
        ],
      ),
    );
  }
}
