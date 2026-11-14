part of 'admin_home_page.dart';

/// Shows one staff member, their organizational context and daily count.
final class _AdminHomeStaffRow extends StatelessWidget {
  const _AdminHomeStaffRow({required this.row});

  final AdminDashboardStaffRow row;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AdminLayoutConstants.overviewStaffRowHeight,
      child: Row(
        spacing: AppSizes.s8,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText.bodyStrong(
                  row.fullName,
                  maxLines: AdminLayoutConstants.overviewMinimumColumnCount,
                  overflow: TextOverflow.ellipsis,
                ),
                AppText.caption(
                  row.caption,
                  tone: TextTone.muted,
                  maxLines: AdminLayoutConstants.overviewMinimumColumnCount,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(
            width: AdminLayoutConstants.overviewStaffProgressWidth,
            child: AppProgressBar(
              value: row.fractionOfMaximum,
              semanticsLabel: row.fullName,
            ),
          ),
          SizedBox(
            width: AdminLayoutConstants.overviewBreakdownCountWidth,
            child: AppText.bodyStrong(
              row.count.toString(),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
