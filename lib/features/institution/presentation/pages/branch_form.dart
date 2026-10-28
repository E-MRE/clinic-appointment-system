part of 'branch_form_page.dart';

final class _BranchForm extends StatefulWidget {
  const _BranchForm({
    required this.branch,
    required this.createSaveCubit,
    super.key,
  });
  final Branch? branch;
  final BranchSaveCubit Function() createSaveCubit;

  @override
  State<_BranchForm> createState() => _BranchFormState();
}
