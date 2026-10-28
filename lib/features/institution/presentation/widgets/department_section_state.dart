part of 'department_section.dart';

final class _DepartmentSectionState extends State<_DepartmentSectionContent> {
  final controller = TextEditingController();
  late final DepartmentSaveCubit saveCubit;

  @override
  void initState() {
    super.initState();
    saveCubit = context.read<DepartmentSaveCubit>();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText.sectionTitle(LocaleKeys.institution_departments.tr()),
          const EmptySize.s12Height(),
          BlocBuilder<DepartmentListCubit, InstitutionListState<Department>>(
            builder: (context, state) {
              final content =
                  InstitutionListView<Department, DepartmentListCubit>(
                    loadingVariant: LoadingStateVariant.centeredIndicator,
                    emptyTitle: LocaleKeys.institution_empty_departmentsTitle
                        .tr(),
                    emptyMessage: LocaleKeys
                        .institution_empty_departmentsDescription
                        .tr(),
                    onRetry: context.read<DepartmentListCubit>().retry,
                    loadedBuilder: (items) {
                      return Column(
                        children: [
                          for (final item in items)
                            AppListTile(
                              title: item.name,
                              trailing: IconButton(
                                tooltip: LocaleKeys.institution_editWorkingHours
                                    .tr(),
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () => _edit(context, item),
                              ),
                            ),
                        ],
                      );
                    },
                  );
              if (state is! InstitutionListLoaded<Department> ||
                  state.items.isEmpty) {
                return SizedBox(height: AppSizes.s144, child: content);
              }
              return content;
            },
          ),
          const EmptySize.s12Height(),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: LocaleKeys.institution_newDepartmentName.tr(),
                  controller: controller,
                ),
              ),
              const EmptySize.s8Width(),
              FilledButton(
                onPressed: _add,
                child: AppText.label(
                  LocaleKeys.institution_add.tr(),
                  tone: TextTone.onPrimary,
                ),
              ),
            ],
          ),
          BlocBuilder<DepartmentSaveCubit, InstitutionSaveState<Department>>(
            builder: (context, state) {
              if (state is InstitutionSaveFailure<Department>) {
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
    );
  }

  Future<void> _add() async {
    if (controller.text.trim().isEmpty) return;
    await saveCubit.create(widget.branchId, controller.text.trim());
    if (mounted && saveCubit.state is InstitutionSaveSaved<Department>) {
      controller.clear();
    }
  }

  Future<void> _edit(BuildContext context, Department item) async {
    final edit = TextEditingController(text: item.name);
    Future<Object?>? dialogCompleted;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        dialogCompleted = ModalRoute.of(dialogContext)?.completed;
        return BlocProvider<DepartmentSaveCubit>(
          create: (_) => AppDependency.injector.get<DepartmentSaveCubit>(),
          child:
              BlocBuilder<
                DepartmentSaveCubit,
                InstitutionSaveState<Department>
              >(
                builder: (context, state) {
                  final editSave = context.read<DepartmentSaveCubit>();
                  return AlertDialog(
                    title: AppText.sectionTitle(
                      LocaleKeys.institution_departments.tr(),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppTextField(
                          label: LocaleKeys.institution_newDepartmentName.tr(),
                          controller: edit,
                        ),
                        if (state is InstitutionSaveFailure<Department>)
                          AppText.caption(
                            state.code.message,
                            tone: TextTone.error,
                          ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: AppText.label(
                          LocaleKeys.institution_cancel.tr(),
                        ),
                      ),
                      FilledButton(
                        onPressed: state is InstitutionSaveSaving<Department>
                            ? null
                            : () async {
                                await editSave.update(item, edit.text.trim());
                                if (dialogContext.mounted &&
                                    editSave.state
                                        is InstitutionSaveSaved<Department>) {
                                  Navigator.pop(dialogContext);
                                }
                              },
                        child: AppText.label(
                          LocaleKeys.institution_save.tr(),
                          tone: TextTone.onPrimary,
                        ),
                      ),
                    ],
                  );
                },
              ),
        );
      },
    );
    await dialogCompleted;
    edit.dispose();
  }
}
