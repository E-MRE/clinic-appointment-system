part of 'staff_form.dart';

/// Selects the staff department and locks existing placement during edits.
final class _StaffFormDepartmentField extends StatelessWidget {
  const _StaffFormDepartmentField({required this.isEditing});

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DepartmentListCubit>().state;
    final values = context.watch<StaffFormCubit>().state;
    final id = values.departmentId;
    return AppSelectField<String>(
      label: LocaleKeys.staff_department.tr(),
      hint: LocaleKeys.staff_selectDepartment.tr(),
      value: id.isEmpty ? null : id,
      enabled: !isEditing,
      options: [
        if (state is InstitutionListLoaded<Department>)
          for (final item in state.items)
            if (item.branchId == values.branchId)
              AppSelectOption(value: item.id, label: item.name),
      ],
      onChanged: (id) =>
          context.read<StaffFormCubit>().selectDepartment(id ?? ''),
      validator: (id) {
        if (id == null || id.trim().isEmpty) {
          return UserErrorCode.departmentRequired.staffMessage;
        }
        return null;
      },
    );
  }
}
