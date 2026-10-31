part of 'staff_management_page.dart';

/// Hosts the responsive staff page and mobile creation action.
final class _StaffManagementPageShell extends StatelessWidget {
  const _StaffManagementPageShell();

  @override
  Widget build(BuildContext context) {
    final hasBranches = context.staffOverview.branchCount > 0;
    return AppScaffold(
      floatingActionButton: context.screenSize.isMobile && hasBranches
          ? AppAddFab(
              label: LocaleKeys.staff_addTitle.tr(),
              onPressed: context.openStaffCreate,
            )
          : null,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StaffManagementHeader(),
          EmptySize.s16Height(),
          Expanded(child: _StaffManagementBranchContent()),
        ],
      ),
    );
  }
}
