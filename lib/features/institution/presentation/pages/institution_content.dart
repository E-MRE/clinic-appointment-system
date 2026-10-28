part of 'institution_page.dart';

/// Layout of a selected clinic and its branch lists.
final class _InstitutionContent extends StatelessWidget {
  const _InstitutionContent({
    required this.clinics,
    required this.onClinicDialog,
  });

  final List<Clinic> clinics;
  final Future<void> Function(BuildContext, [Clinic?]) onClinicDialog;

  @override
  Widget build(BuildContext context) {
    final selection = InstitutionSelectionScope.of(context);
    final clinic = clinics.firstWhere(
      (item) => item.id == selection.clinicId,
      orElse: () => clinics.first,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: clinic.name,
          subtitle: _counts(context),
          actions: IconButton(
            tooltip: LocaleKeys.institution_editClinic.tr(),
            onPressed: () => onClinicDialog(context, clinic),
            icon: const Icon(Icons.edit_outlined),
          ),
        ),
        if (clinics.length > 1) ...[
          AppSelectField<String>(
            label: LocaleKeys.institution_selectClinic.tr(),
            value: clinic.id,
            options: [
              for (final item in clinics)
                AppSelectOption(value: item.id, label: item.name),
            ],
            onChanged: (value) {
              if (value != null) selection.selectClinic(value);
            },
          ),
          const EmptySize.s12Height(),
          OutlinedButton.icon(
            onPressed: () => onClinicDialog(context),
            icon: const Icon(Icons.add),
            label: AppText.label(LocaleKeys.institution_newClinic.tr()),
          ),
        ],
        const EmptySize.s16Height(),
        Row(
          children: [
            Expanded(
              child: AppText.sectionTitle(LocaleKeys.institution_branches.tr()),
            ),
            if (!context.screenSize.isMobile)
              FilledButton.icon(
                onPressed: () => context.go(AppRoutes.branchNew(clinic.id)),
                icon: const Icon(Icons.add),
                label: AppText.label(
                  LocaleKeys.institution_addBranch.tr(),
                  tone: TextTone.onPrimary,
                ),
              ),
          ],
        ),
        const EmptySize.s12Height(),
        Expanded(
          child: InstitutionListView<Branch, BranchListCubit>(
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
            loadedBuilder: (branches) =>
                _InstitutionBranches(branches: branches),
          ),
        ),
        if (context.screenSize.isMobile)
          Align(
            alignment: Alignment.centerRight,
            child: FloatingActionButton.extended(
              onPressed: () => context.go(AppRoutes.branchNew(clinic.id)),
              icon: const Icon(Icons.add),
              label: AppText.label(
                LocaleKeys.institution_addBranch.tr(),
                tone: TextTone.onPrimary,
              ),
            ),
          ),
      ],
    );
  }

  String _counts(BuildContext context) {
    final branches = context.watch<BranchListCubit>().state;
    final departments = context.watch<DepartmentListCubit>().state;
    final branchCount = branches is InstitutionListLoaded<Branch>
        ? branches.items.length
        : 0;
    final departmentCount = departments is InstitutionListLoaded<Department>
        ? departments.items.length
        : 0;
    return '${LocaleKeys.institution_branchesCount.tr(args: ['$branchCount'])} · ${LocaleKeys.institution_departmentsCount.tr(args: ['$departmentCount'])}';
  }
}
