part of 'branch_detail_page.dart';

/// Resolves the selected branch and shows its details.
final class _BranchDetailContent extends StatelessWidget {
  const _BranchDetailContent({required this.branchId});

  final String branchId;

  @override
  Widget build(BuildContext context) {
    return InstitutionListView<Branch, BranchListCubit>(
      emptyTitle: LocaleKeys.institution_notFound.tr(),
      emptyMessage: LocaleKeys.institution_notFoundDescription.tr(),
      onRetry: context.read<BranchListCubit>().retry,
      loadedBuilder: (items) {
        final matches = items.where((item) => item.id == branchId);
        if (matches.isEmpty) return const InstitutionNotFound();
        return _BranchDetailBody(branch: matches.first);
      },
    );
  }
}
