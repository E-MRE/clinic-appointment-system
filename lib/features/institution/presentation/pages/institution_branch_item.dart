part of 'institution_page.dart';

/// One branch as a card or a desktop list tile.
final class _InstitutionBranchItem extends StatelessWidget {
  const _InstitutionBranchItem({required this.branch});

  final Branch branch;

  @override
  Widget build(BuildContext context) {
    final selection = InstitutionSelectionScope.of(context);
    if (context.screenSize.isMobile) {
      return InstitutionBranchCard(
        branch: branch,
        onTap: () {
          selection.selectBranch(branch.id);
          context.go(AppRoutes.branchDetail(branch.clinicId, branch.id));
        },
      );
    }
    return AppSurface(
      child: AppListTile(
        title: branch.name,
        subtitle: '${branch.address} · ${branch.workingHours.localizedSummary}',
        trailing: const Icon(Icons.chevron_right),
        onTap: () => selection.selectBranch(branch.id),
      ),
    );
  }
}
