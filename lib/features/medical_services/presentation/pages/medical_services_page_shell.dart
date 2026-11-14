part of 'medical_services_page.dart';

/// Hosts the medical services responsive scaffold and layout.
final class _MedicalServicesPageShell extends StatelessWidget {
  const _MedicalServicesPageShell();

  @override
  Widget build(BuildContext context) {
    final isMobile = context.screenSize.isMobile;
    final branchId = InstitutionSelectionScope.of(context).branchId;

    return MultiBlocListener(
      listeners: [
        BlocListener<DepartmentListCubit, InstitutionListState<Department>>(
          listener: _onDepartmentsChanged,
        ),
        BlocListener<MedicalServiceFilterCubit, MedicalServiceKindFilter>(
          listener: _onFilterChanged,
        ),
      ],
      child: AppScaffold(
        floatingActionButton: isMobile && branchId != null
            ? AppAddFab(
                label: LocaleKeys.services_addService.tr(),
                onPressed: () => context.go(AppRoutes.serviceNew),
              )
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _MedicalServicesHeader(),
            const EmptySize.s16Height(),
            Expanded(
              child: branchId == null
                  ? const _MedicalServicesNoBranch()
                  : const _MedicalServicesContent(),
            ),
          ],
        ),
      ),
    );
  }

  void _onDepartmentsChanged(
    BuildContext context,
    InstitutionListState<Department> state,
  ) {
    if (state is InstitutionListLoaded<Department>) {
      context.read<MedicalServiceListCubit>().updateDepartments(state.items);
    }
  }

  void _onFilterChanged(BuildContext context, MedicalServiceKindFilter filter) {
    context.read<MedicalServiceListCubit>().updateFilter(filter);
  }
}
