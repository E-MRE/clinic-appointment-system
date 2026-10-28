part of 'branch_detail_page.dart';

final class _BranchDetailPageState extends State<BranchDetailPage> {
  @override
  void initState() {
    super.initState();
    _selectBranchAfterFrame();
  }

  /// The router reuses this state when only the branch id changes.
  @override
  void didUpdateWidget(BranchDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.branchId != widget.branchId) _selectBranchAfterFrame();
  }

  void _selectBranchAfterFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        InstitutionSelectionScope.of(context).selectBranch(widget.branchId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: BlocBuilder<BranchListCubit, InstitutionListState<Branch>>(
        builder: (context, state) {
          if (state is InstitutionListLoaded<Branch>) {
            final matches = state.items.where(
              (item) => item.id == widget.branchId,
            );
            if (matches.isEmpty) return _missing(context);
            final branch = matches.first;
            return Column(
              children: [
                PageHeader(title: branch.name, subtitle: branch.address),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        WorkingHoursSection(
                          hours: branch.workingHours,
                          onEdit: () => context.go(
                            AppRoutes.branchEdit(branch.clinicId, branch.id),
                          ),
                        ),
                        const EmptySize.s16Height(),
                        DepartmentSection(
                          key: ValueKey(branch.id),
                          branchId: branch.id,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return InstitutionListView<Branch, BranchListCubit>(
            emptyTitle: LocaleKeys.institution_notFound.tr(),
            emptyMessage: LocaleKeys.institution_notFoundDescription.tr(),
            onRetry: context.read<BranchListCubit>().retry,
            loadedBuilder: (_) => _missing(context),
          );
        },
      ),
    );
  }

  Widget _missing(BuildContext context) {
    return EmptyState(
      title: LocaleKeys.institution_notFound.tr(),
      message: LocaleKeys.institution_notFoundDescription.tr(),
      icon: const Icon(Icons.search_off),
      iconBackground: context.colorScheme.surfaceContainerHighest,
    );
  }
}
