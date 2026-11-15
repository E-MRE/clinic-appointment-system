part of 'admin_home_page.dart';

/// Provides branch selection and navigation to the appointment list.
final class _AdminHomeHeaderActions extends StatelessWidget {
  const _AdminHomeHeaderActions();

  @override
  Widget build(BuildContext context) {
    final catalogState = context.watch<ClinicCatalogCubit>().state;
    final dashboardState = context.watch<AdminDashboardCubit>().state;
    final selectedBranchId = dashboardState is AdminDashboardLoaded
        ? dashboardState.summary.selectedBranchId
        : null;
    return Wrap(
      spacing: AppSizes.s12,
      runSpacing: AppSizes.s8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _branchSelector(context, catalogState, selectedBranchId),
        _appointmentsButton(context),
      ],
    );
  }

  String? _branchId(String? value) {
    if (value == _allBranchesValue) return null;
    return value;
  }

  String get _allBranchesValue => '';

  Widget _branchSelector(
    BuildContext context,
    ClinicCatalogState catalogState,
    String? selectedBranchId,
  ) {
    return SizedBox(
      width: AdminLayoutConstants.overviewBranchSelectWidth,
      child: AppSelectField<String>(
        label: LocaleKeys.admin_appointmentsPage_branch.translate(),
        showLabel: false,
        enabled: catalogState is ClinicCatalogLoaded,
        value: selectedBranchId ?? _allBranchesValue,
        options: [
          AppSelectOption<String>(
            value: _allBranchesValue,
            label: LocaleKeys.admin_appointmentsPage_allBranches.translate(),
          ),
          if (catalogState is ClinicCatalogLoaded)
            for (final branch in catalogState.catalog.branches)
              AppSelectOption<String>(value: branch.id, label: branch.name),
        ],
        onChanged: (value) {
          context.read<AdminDashboardCubit>().selectBranch(_branchId(value));
        },
      ),
    );
  }

  Widget _appointmentsButton(BuildContext context) {
    return FilledButton(
      onPressed: () {
        context.go(AppRoutes.adminAppointments);
      },
      child: AppText.label(
        LocaleKeys.admin_appointmentsTitle.translate(),
        tone: TextTone.onPrimary,
      ),
    );
  }
}
