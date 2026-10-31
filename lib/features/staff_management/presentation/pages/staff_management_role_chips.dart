part of 'staff_management_page.dart';

/// Shows unfiltered clinic-wide role counts with a single selection.
final class _StaffManagementRoleChips extends StatelessWidget {
  const _StaffManagementRoleChips();

  @override
  Widget build(BuildContext context) {
    final overview = context.staffOverview;
    final filter = context.watch<StaffFilterCubit>().state;
    return AppFilterChips<StaffRoleFilter>(
      selected: filter.role,
      choices: [
        for (final role in StaffRoleFilter.values)
          AppChoice(value: role, label: overview.chipLabel(role)),
      ],
      onSelected: context.read<StaffFilterCubit>().selectRole,
    );
  }
}
