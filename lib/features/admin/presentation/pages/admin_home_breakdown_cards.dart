part of 'admin_home_page.dart';

/// Arranges status, department and staff summaries in a responsive row.
final class _AdminHomeBreakdownCards extends StatelessWidget {
  const _AdminHomeBreakdownCards({required this.summary});

  final AdminDashboardSummary summary;

  int _columnCount(double width) {
    const gap = AppSizes.s16;
    final estimated =
        ((width + gap) /
                (AdminLayoutConstants.overviewBreakdownCardMinWidth + gap))
            .floor();
    if (estimated < AdminLayoutConstants.overviewMinimumColumnCount) {
      return AdminLayoutConstants.overviewMinimumColumnCount;
    }
    if (estimated > AdminLayoutConstants.overviewBreakdownCardCount) {
      return AdminLayoutConstants.overviewBreakdownCardCount;
    }
    return estimated;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = _columnCount(constraints.maxWidth);
        final columnGaps =
            columns - AdminLayoutConstants.overviewMinimumColumnCount;
        final cardWidth =
            (constraints.maxWidth - AppSizes.s16 * columnGaps) / columns;
        return Wrap(
          spacing: AppSizes.s16,
          runSpacing: AppSizes.s16,
          children: [
            SizedBox(
              width: cardWidth,
              child: _AdminHomeStatusCard(summary: summary),
            ),
            SizedBox(
              width: cardWidth,
              child: _AdminHomeDepartmentCard(summary: summary),
            ),
            SizedBox(
              width: cardWidth,
              child: _AdminHomeStaffCard(summary: summary),
            ),
          ],
        );
      },
    );
  }
}
