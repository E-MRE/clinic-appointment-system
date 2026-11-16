part of 'admin_home_page.dart';

/// Selects the branch used to filter the administrator overview.
final class _AdminHomeHeaderBranchSelector extends StatelessWidget {
  /// Creates a branch selector from the current catalog and selection.
  const _AdminHomeHeaderBranchSelector({
    required this.catalogState,
    required this.selectedBranchId,
  });

  final ClinicCatalogState catalogState;
  final String? selectedBranchId;

  /// The empty option represents all branches.
  String get _allBranchesValue => '';

  @override
  Widget build(BuildContext context) {
    final catalogState = this.catalogState;
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

  String? _branchId(String? value) {
    if (value == _allBranchesValue) return null;
    return value;
  }
}
