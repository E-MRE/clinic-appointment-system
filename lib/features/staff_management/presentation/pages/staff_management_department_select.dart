part of 'staff_management_page.dart';

/// Selects a shared department name across all clinic branches.
final class _StaffManagementDepartmentSelect extends StatelessWidget {
  const _StaffManagementDepartmentSelect();

  @override
  Widget build(BuildContext context) {
    final overview = context.staffOverview;
    final selected = context.watch<StaffFilterCubit>().state.departmentName;
    return AppSelectField<String?>(
      label: LocaleKeys.staff_department.tr(),
      value: selected,
      hint: LocaleKeys.staff_allDepartments.tr(),
      options: [
        AppSelectOption(
          value: null,
          label: LocaleKeys.staff_allDepartments.tr(),
        ),
        for (final name in overview.departmentNames)
          AppSelectOption(value: name, label: name),
      ],
      onChanged: context.read<StaffFilterCubit>().selectDepartment,
    );
  }
}
