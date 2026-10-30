part of 'medical_service_form.dart';

/// Select field choosing the clinical department providing the service.
final class _MedicalServiceFormDepartmentField extends StatelessWidget
    with InstitutionInputValidationMixin, MedicalServiceInputValidationMixin {
  const _MedicalServiceFormDepartmentField({required this.isEditing});

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    final departmentState = context.watch<DepartmentListCubit>().state;
    final departments = departmentState is InstitutionListLoaded<Department>
        ? departmentState.items
        : const <Department>[];

    final currentId = context.select<MedicalServiceFormCubit, String>(
      (c) => c.state.departmentId,
    );
    final formCubit = context.read<MedicalServiceFormCubit>();

    return AppSelectField<String>(
      label: LocaleKeys.services_department.tr(),
      hint: LocaleKeys.services_selectDepartment.tr(),
      value: currentId.isEmpty ? null : currentId,
      enabled: !isEditing,
      options: [
        for (final dept in departments)
          AppSelectOption(value: dept.id, label: dept.name),
      ],
      onChanged: (id) => formCubit.selectDepartment(id ?? ''),
      validator: (id) => departmentError(id ?? '')?.message,
    );
  }
}
