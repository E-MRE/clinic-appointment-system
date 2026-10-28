part of 'branch_detail_page.dart';

/// Branch heading, hours and department details.
final class _BranchDetailBody extends StatelessWidget {
  const _BranchDetailBody({required this.branch});

  final Branch branch;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(title: branch.name, subtitle: branch.address),
        Expanded(child: _BranchDetailSections(branch: branch)),
      ],
    );
  }
}
