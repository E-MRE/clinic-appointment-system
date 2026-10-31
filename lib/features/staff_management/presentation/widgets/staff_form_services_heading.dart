part of 'staff_form.dart';

/// Names the selected department above its eligible services.
final class _StaffFormServicesHeading extends StatelessWidget {
  const _StaffFormServicesHeading();

  @override
  Widget build(BuildContext context) {
    final values = context.watch<StaffFormCubit>().state;
    final state = context.watch<DepartmentListCubit>().state;
    final departments = <Department>[
      if (state is InstitutionListLoaded<Department>)
        for (final department in state.items)
          if (department.id == values.departmentId &&
              department.branchId == values.branchId)
            department,
    ];
    return Semantics(
      header: true,
      child: AppText.label(
        LocaleKeys.staff_servicesHeading.tr(
          args: [
            departments.firstOrNull?.name ??
                LocaleKeys.staff_selectDepartment.tr(),
          ],
        ),
      ),
    );
  }
}
