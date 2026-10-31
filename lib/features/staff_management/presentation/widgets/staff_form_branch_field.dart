part of 'staff_form.dart';

/// Selects the staff branch and locks existing placement during edits.
final class _StaffFormBranchField extends StatelessWidget {
  const _StaffFormBranchField({required this.isEditing});

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BranchListCubit>().state;
    final values = context.watch<StaffFormCubit>().state;
    final id = values.branchId;
    return AppSelectField<String>(
      label: LocaleKeys.staff_branch.tr(),
      hint: LocaleKeys.staff_selectBranch.tr(),
      value: id.isEmpty ? null : id,
      enabled: !isEditing,
      options: [
        if (state is InstitutionListLoaded<Branch>)
          for (final item in state.items)
            AppSelectOption(value: item.id, label: item.name),
      ],
      onChanged: (id) => context.read<StaffFormCubit>().selectBranch(id ?? ''),
      validator: (id) {
        if (id == null || id.trim().isEmpty) {
          return UserErrorCode.branchRequired.staffMessage;
        }
        return null;
      },
    );
  }
}
