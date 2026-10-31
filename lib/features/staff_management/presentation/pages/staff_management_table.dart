part of 'staff_management_page.dart';

/// Shared scrollable table for tablet and desktop staff management.
final class _StaffManagementTable extends StatelessWidget {
  const _StaffManagementTable({required this.staff});

  final List<Staff> staff;

  @override
  Widget build(BuildContext context) {
    if (staff.isEmpty) {
      return const _StaffManagementFilteredEmpty();
    }
    return AppDataTable<Staff>(
      rows: staff,
      minWidth: BreakpointsConstants.desktop,
      rowVerticalPadding: AppSizes.s8,
      header: const Padding(
        padding: AppPadding.allLg(),
        child: _StaffManagementFilters(),
      ),
      columns: _columns(context),
    );
  }

  List<AppTableColumn<Staff>> _columns(BuildContext context) {
    final overview = context.staffOverview;
    return [
      AppTableColumn<Staff>(
        label: LocaleKeys.staff_columns_name.tr(),
        cellBuilder: (_, member) {
          return _StaffManagementTableCell(
            staff: member,
            child: _StaffManagementNameCell(staff: member),
          );
        },
      ),
      AppTableColumn<Staff>(
        label: LocaleKeys.staff_columns_role.tr(),
        cellBuilder: (_, member) {
          return _StaffManagementTableCell(
            staff: member,
            child: AppText.body(member.role.staffLabel),
          );
        },
      ),
      AppTableColumn<Staff>(
        label: LocaleKeys.staff_columns_placement.tr(),
        cellBuilder: (_, member) {
          return _StaffManagementTableCell(
            staff: member,
            child: AppText.body(overview.placement(member)),
          );
        },
      ),
      AppTableColumn<Staff>(
        label: LocaleKeys.staff_columns_services.tr(),
        cellBuilder: (_, member) {
          return _StaffManagementTableCell(
            staff: member,
            child: AppText.body(overview.serviceLabel(member)),
          );
        },
      ),
      AppTableColumn<Staff>(
        label: '',
        semanticsLabel: LocaleKeys.staff_columns_actions.tr(),
        alignment: AppTableAlignment.end,
        cellBuilder: (context, member) {
          return IconButton(
            onPressed: () => context.openStaffEdit(member),
            tooltip: LocaleKeys.staff_editTooltip.tr(),
            icon: const Icon(Icons.edit_outlined),
          );
        },
      ),
    ];
  }
}
