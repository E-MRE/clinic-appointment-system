part of 'department_section.dart';

/// Connects department actions to the section's request Cubit.
final class _DepartmentSectionContent extends StatefulWidget {
  const _DepartmentSectionContent({required this.branchId});

  final String branchId;

  @override
  State<_DepartmentSectionContent> createState() => _DepartmentSectionState();
}

final class _DepartmentSectionState extends State<_DepartmentSectionContent>
    with _DepartmentSectionStateMixin {
  @override
  Widget build(BuildContext context) {
    return AppSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText.sectionTitle(LocaleKeys.institution_departments.tr()),
          const EmptySize.s12Height(),
          _buildDepartmentList(),
          const EmptySize.s12Height(),
          _DepartmentAddRow(controller: controller, onAdd: add),
          _buildSaveError(),
        ],
      ),
    );
  }

  /// Shows department request states and the loaded rows.
  Widget _buildDepartmentList() {
    return BlocBuilder<DepartmentListCubit, InstitutionListState<Department>>(
      builder: (context, state) {
        if (state is InstitutionListLoaded<Department> &&
            state.items.isNotEmpty) {
          return _buildDepartmentListContent(context);
        }
        return SizedBox(
          height: AppSizes.s144,
          child: _buildDepartmentListContent(context),
        );
      },
    );
  }

  /// Builds the shared list state presentation for this section.
  Widget _buildDepartmentListContent(BuildContext context) {
    return InstitutionListView<Department, DepartmentListCubit>(
      loadingVariant: LoadingStateVariant.centeredIndicator,
      emptyTitle: LocaleKeys.institution_empty_departmentsTitle.tr(),
      emptyMessage: LocaleKeys.institution_empty_departmentsDescription.tr(),
      onRetry: context.read<DepartmentListCubit>().retry,
      loadedBuilder: (items) => _DepartmentRows(items: items),
    );
  }

  /// Displays a failed department create request.
  Widget _buildSaveError() {
    return BlocBuilder<DepartmentSaveCubit, InstitutionSaveState<Department>>(
      builder: (context, state) {
        if (state is InstitutionSaveFailure<Department>) {
          return AppText.caption(state.code.message, tone: TextTone.error);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
