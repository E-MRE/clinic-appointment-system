part of 'admin_home_page.dart';

/// Shows one department name, count and relative measure.
final class _AdminHomeDepartmentRow extends StatelessWidget {
  const _AdminHomeDepartmentRow({required this.row});

  final AdminDashboardDepartmentRow row;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s8,
      children: [
        Row(
          spacing: AppSizes.s8,
          children: [
            Expanded(
              child: AppText.body(
                row.name,
                maxLines: AdminLayoutConstants.overviewMinimumColumnCount,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AppText.bodyStrong(row.count.toString()),
          ],
        ),
        AppProgressBar(value: row.fractionOfMaximum, semanticsLabel: row.name),
      ],
    );
  }
}
