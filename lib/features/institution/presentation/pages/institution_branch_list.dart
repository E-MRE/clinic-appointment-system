part of 'institution_page.dart';

/// Builds branch rows for the current screen size.
final class _InstitutionBranchList extends StatelessWidget {
  const _InstitutionBranchList({required this.branches});

  final List<Branch> branches;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: branches.length,
      separatorBuilder: (_, _) => const EmptySize.s8Height(),
      itemBuilder: (context, index) =>
          _InstitutionBranchItem(branch: branches[index]),
    );
  }
}
