part of 'institution_page.dart';

/// Branch request states and the add action for an empty list.
final class _InstitutionContentBranches extends StatelessWidget {
  const _InstitutionContentBranches({required this.clinic});

  final Clinic clinic;

  @override
  Widget build(BuildContext context) {
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
      loadedBuilder: (branches) => _InstitutionBranches(branches: branches),
    );
  }
}
