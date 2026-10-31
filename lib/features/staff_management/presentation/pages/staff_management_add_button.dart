part of 'staff_management_page.dart';

/// Adds staff through the editor appropriate to the current screen.
final class _StaffManagementAddButton extends StatelessWidget {
  const _StaffManagementAddButton();

  @override
  Widget build(BuildContext context) {
    return AppAddButton(
      label: LocaleKeys.staff_addTitle.tr(),
      onPressed: context.staffOverview.branchCount == 0
          ? null
          : context.openStaffCreate,
    );
  }
}
