part of 'branch_form_page.dart';

/// Edits branch fields and working hours, then saves through the request Cubit.
final class _BranchForm extends StatefulWidget {
  const _BranchForm({required this.branch});
  final Branch? branch;

  @override
  State<_BranchForm> createState() => _BranchFormState();
}

final class _BranchFormState extends State<_BranchForm> {
  late final TextEditingController name;
  late final TextEditingController address;
  late final WorkingHoursEditorCubit editor;
  late final BranchSaveCubit save;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.branch?.name);
    address = TextEditingController(text: widget.branch?.address);
    editor = context.read<WorkingHoursEditorCubit>();
    save = context.read<BranchSaveCubit>();
  }

  @override
  void dispose() {
    name.dispose();
    address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BranchSaveCubit, InstitutionSaveState<Branch>>(
      listener: _onSaveState,
      child: AppScaffold(
        child: Column(
          children: [
            PageHeader(
              title:
                  widget.branch?.name ?? LocaleKeys.institution_newBranch.tr(),
            ),
            Expanded(
              child: _BranchFormFields(name: name, address: address),
            ),
            const EmptySize.s12Height(),
            _BranchFormActions(onSave: _save),
          ],
        ),
      ),
    );
  }

  void _onSaveState(BuildContext context, InstitutionSaveState<Branch> state) {
    if (state is InstitutionSaveSaved<Branch>) {
      InstitutionSelectionScope.read(context).selectBranch(state.value.id);
      context.go(
        context.screenSize.isMobile
            ? AppRoutes.branchDetail(state.value.clinicId, state.value.id)
            : AppRoutes.institution,
      );
    }
  }

  void _save() {
    final hours = editor.build();
    if (hours == null) return;
    final branch = widget.branch;
    if (branch == null) {
      final clinicId = InstitutionSelectionScope.read(context).clinicId;
      if (clinicId == null) return;
      save.create(
        BranchDraft(
          clinicId: clinicId,
          name: name.text.trim(),
          address: address.text.trim(),
          workingHours: hours,
        ),
      );
    } else {
      save.update(
        Branch(
          id: branch.id,
          clinicId: branch.clinicId,
          name: name.text.trim(),
          address: address.text.trim(),
          workingHours: hours,
        ),
      );
    }
  }
}
