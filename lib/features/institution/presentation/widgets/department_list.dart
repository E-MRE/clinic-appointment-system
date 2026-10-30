part of 'department_section.dart';

/// Shows department request states and the loaded rows.
final class _DepartmentList extends StatelessWidget {
  const _DepartmentList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentListCubit, InstitutionListState<Department>>(
      builder: (context, state) {
        final content = InstitutionListView<Department, DepartmentListCubit>(
          loadingVariant: LoadingStateVariant.centeredIndicator,
          emptyTitle: LocaleKeys.institution_empty_departmentsTitle.tr(),
          emptyMessage: LocaleKeys.institution_empty_departmentsDescription
              .tr(),
          onRetry: context.read<DepartmentListCubit>().retry,
          loadedBuilder: (items) => _DepartmentRows(items: items),
        );
        if (state is InstitutionListLoaded<Department> &&
            state.items.isNotEmpty) {
          return content;
        }
        return SizedBox(height: AppSizes.s144, child: content);
      },
    );
  }
}
