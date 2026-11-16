part of 'admin_home_page.dart';

/// Shows a staff member's name and organizational caption.
final class _AdminHomeStaffRowIdentity extends StatelessWidget {
  /// Creates the identity content for the supplied staff row.
  const _AdminHomeStaffRowIdentity({required this.row});

  final AdminDashboardStaffRow row;

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
