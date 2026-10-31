part of 'staff_management_page.dart';

/// Applies role and department filters after restricting staff to this clinic.
final class _StaffManagementLoaded extends StatelessWidget {
  const _StaffManagementLoaded();

  @override
  Widget build(BuildContext context) {
    final overview = context.staffOverview;
    if (overview.staff.isEmpty) return const _StaffManagementEmpty();
    final filter = context.watch<StaffFilterCubit>().state;
    final staff = overview.filtered(filter);
    if (context.screenSize.isMobile) {
      return _StaffManagementMobileView(staff: staff);
    }
    return SingleChildScrollView(child: _StaffManagementTable(staff: staff));
  }
}
