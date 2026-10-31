part of 'staff_management_page.dart';

/// Stacks filters on mobile and shares a row on wider screens.
final class _StaffManagementFilters extends StatelessWidget {
  const _StaffManagementFilters();

  @override
  Widget build(BuildContext context) {
    if (context.screenSize.isMobile) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s12,
        children: [
          _StaffManagementRoleChips(),
          _StaffManagementDepartmentSelect(),
        ],
      );
    }
    return const Row(
      spacing: AppSizes.s16,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: _StaffManagementRoleChips()),
        Expanded(child: _StaffManagementDepartmentSelect()),
      ],
    );
  }
}
