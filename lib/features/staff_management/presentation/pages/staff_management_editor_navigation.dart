part of 'staff_management_page.dart';

/// Chooses the staff panel, dialog or mobile route for the current screen.
extension _StaffManagementEditorNavigation on BuildContext {
  /// Opens a new staff draft.
  void openStaffCreate() {
    if (screenSize.isDesktop) {
      read<StaffEditorCubit>().startCreate();
    } else if (screenSize.isTablet) {
      _showStaffDialog();
    } else {
      go(AppRoutes.adminStaffNew);
    }
  }

  /// Opens the editor for an existing profile.
  void openStaffEdit(Staff staff) {
    if (screenSize.isDesktop) {
      read<StaffEditorCubit>().edit(staff);
    } else if (screenSize.isTablet) {
      _showStaffDialog(staff: staff);
    } else {
      go(AppRoutes.adminStaffEdit(staff.id));
    }
  }

  /// The dialog route needs the branch list provided above the page.
  Future<void> _showStaffDialog({Staff? staff}) {
    final branches = read<BranchListCubit>();
    return showDialog<void>(
      context: this,
      builder: (_) {
        return BlocProvider<BranchListCubit>.value(
          value: branches,
          child: _StaffManagementFormDialog(staff: staff),
        );
      },
    );
  }
}
