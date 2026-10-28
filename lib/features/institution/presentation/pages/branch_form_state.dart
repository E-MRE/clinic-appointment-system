part of 'branch_form_page.dart';

final class _BranchFormState extends State<_BranchForm> {
  late final name = TextEditingController(text: widget.branch?.name);
  late final address = TextEditingController(text: widget.branch?.address);
  late final editor = WorkingHoursEditorCubit(
    initialHours: widget.branch?.workingHours,
  );
  late final save = widget.createSaveCubit();

  @override
  void dispose() {
    name.dispose();
    address.dispose();
    editor.close();
    save.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WorkingHoursEditorCubit>.value(value: editor),
        BlocProvider<BranchSaveCubit>.value(value: save),
      ],
      child: BlocListener<BranchSaveCubit, InstitutionSaveState<Branch>>(
        listener: (context, state) {
          if (state is InstitutionSaveSaved<Branch>) {
            InstitutionSelectionScope.of(context).selectBranch(state.value.id);
            context.go(
              context.screenSize.isMobile
                  ? AppRoutes.branchDetail(state.value.clinicId, state.value.id)
                  : AppRoutes.institution,
            );
          }
        },
        child: AppScaffold(
          child: Column(
            children: [
              PageHeader(
                title:
                    widget.branch?.name ??
                    LocaleKeys.institution_newBranch.tr(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        label: LocaleKeys.institution_branchName.tr(),
                        controller: name,
                      ),
                      const EmptySize.s16Height(),
                      AppTextField(
                        label: LocaleKeys.institution_address.tr(),
                        controller: address,
                      ),
                      const EmptySize.s16Height(),
                      const WorkingHoursEditor(),
                      BlocBuilder<
                        BranchSaveCubit,
                        InstitutionSaveState<Branch>
                      >(
                        builder: (context, state) {
                          if (state is InstitutionSaveFailure<Branch>) {
                            return AppText.caption(
                              state.code.message,
                              tone: TextTone.error,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const EmptySize.s12Height(),
              Row(
                children: [
                  TextButton(
                    onPressed: () => context.go(AppRoutes.institution),
                    child: AppText.label(LocaleKeys.institution_cancel.tr()),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _save,
                    child: AppText.label(
                      LocaleKeys.institution_saveBranch.tr(),
                      tone: TextTone.onPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    final hours = editor.build();
    if (hours == null) return;
    final branch = widget.branch;
    if (branch == null) {
      final clinicId = InstitutionSelectionScope.of(context).clinicId;
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
