part of 'institution_page.dart';

/// Responsive branch list and selected branch details.
final class _InstitutionBranches extends StatelessWidget {
  const _InstitutionBranches({required this.branches});

  final List<Branch> branches;

  @override
  Widget build(BuildContext context) {
    if (context.screenSize.isMobile) {
      return _InstitutionBranchList(branches: branches);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _InstitutionBranchList(branches: branches)),
        const EmptySize.s16Width(),
        Expanded(child: _InstitutionBranchDetails(branches: branches)),
      ],
    );
  }
}
