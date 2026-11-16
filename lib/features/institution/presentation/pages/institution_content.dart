part of 'institution_page.dart';

/// Layout of a selected clinic and its branch lists.
final class _InstitutionContent extends StatelessWidget {
  const _InstitutionContent({required this.clinics});

  final List<Clinic> clinics;

  @override
  Widget build(BuildContext context) {
    final selection = InstitutionSelectionScope.of(context);
    final clinic = clinics.firstWhere(
      (item) => item.id == selection.clinicId,
      orElse: () => clinics.first,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InstitutionClinicHeader(clinic: clinic),
        if (clinics.length > 1)
          _InstitutionClinicPicker(clinics: clinics, clinic: clinic),
        const EmptySize.s16Height(),
        _InstitutionBranchHeader(clinic: clinic),
        const EmptySize.s12Height(),
        Expanded(child: _buildBranchContent(context, clinic)),
        if (context.screenSize.isMobile) _buildMobileAddBranch(context, clinic),
      ],
    );
  }

  /// Builds branch request states and the empty-list add action.
  Widget _buildBranchContent(BuildContext context, Clinic clinic) {
    return InstitutionListView<Branch, BranchListCubit>(
      emptyTitle: LocaleKeys.institution_empty_branchesTitle.tr(),
      emptyMessage: LocaleKeys.institution_empty_branchesDescription.tr(),
      onRetry: context.read<BranchListCubit>().retry,
      emptyAction: FilledButton(
        onPressed: () => context.go(AppRoutes.branchNew(clinic.id)),
        child: AppText.label(
          LocaleKeys.institution_addBranch.tr(),
          tone: TextTone.onPrimary,
        ),
      ),
      loadedBuilder: (branches) => _buildBranches(context, branches),
    );
  }

  /// Builds the responsive branch list and selected details.
  Widget _buildBranches(BuildContext context, List<Branch> branches) {
    if (context.screenSize.isMobile) {
      return _buildBranchList(branches);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildBranchList(branches)),
        const EmptySize.s16Width(),
        Expanded(child: _InstitutionBranchDetails(branches: branches)),
      ],
    );
  }

  /// Builds the branch rows for the current screen size.
  Widget _buildBranchList(List<Branch> branches) {
    return ListView.separated(
      itemCount: branches.length,
      separatorBuilder: (_, _) => const EmptySize.s8Height(),
      itemBuilder: (context, index) =>
          _InstitutionBranchItem(branch: branches[index]),
    );
  }

  /// Builds the mobile action for adding a branch.
  Widget _buildMobileAddBranch(BuildContext context, Clinic clinic) {
    return Align(
      alignment: Alignment.centerRight,
      child: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.branchNew(clinic.id)),
        icon: const Icon(Icons.add),
        label: AppText.label(
          LocaleKeys.institution_addBranch.tr(),
          tone: TextTone.onPrimary,
        ),
      ),
    );
  }
}
