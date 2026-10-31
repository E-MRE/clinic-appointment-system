part of 'staff_management_page.dart';

/// Displays the stored full name and initials in the staff table.
final class _StaffManagementNameCell extends StatelessWidget {
  const _StaffManagementNameCell({required this.staff});

  final Staff staff;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSizes.s12,
      children: [
        AppAvatar(initials: staff.initials),
        Flexible(child: AppText.bodyStrong(staff.fullName)),
      ],
    );
  }
}
