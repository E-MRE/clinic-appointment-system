part of 'staff_management_page.dart';

/// Opens the tablet edit dialog when staff row content is tapped.
final class _StaffManagementTableCell extends StatelessWidget {
  const _StaffManagementTableCell({required this.staff, required this.child});

  final Staff staff;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (context.screenSize.isTablet) {
      return InkWell(onTap: () => context.openStaffEdit(staff), child: child);
    }
    return child;
  }
}
