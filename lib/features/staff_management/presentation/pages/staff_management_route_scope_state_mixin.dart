part of 'staff_management_route_scope.dart';

/// Replaces lookup observations when the selected clinic's branch ids change.
mixin _StaffManagementRouteScopeStateMixin
    on State<_StaffManagementRouteScopeContent> {
  late final BranchListCubit _branches;
  late final StaffDepartmentListCubit _departments;
  late final StaffServiceListCubit _services;
  late final InstitutionSelection _selection;
  late final StreamSubscription<InstitutionListState<Branch>> _subscription;
  List<String>? _watchedBranchIds;

  @override
  void initState() {
    super.initState();
    _branches = context.read<BranchListCubit>();
    _departments = context.read<StaffDepartmentListCubit>();
    _services = context.read<StaffServiceListCubit>();
    _selection = InstitutionSelectionScope.read(context);
    _subscription = _branches.stream.listen((_) => _syncBranches());
    _selection.addListener(_syncBranches);
    _syncBranches();
  }

  @override
  void dispose() {
    _selection.removeListener(_syncBranches);
    _subscription.cancel();
    super.dispose();
  }

  void _syncBranches() {
    final state = _branches.state;
    final clinicId = _selection.clinicId;
    final branchIds = <String>[
      if (state is InstitutionListLoaded<Branch>)
        for (final branch in state.items)
          if (clinicId != null && branch.clinicId == clinicId) branch.id,
    ]..sort();
    if (listEquals(branchIds, _watchedBranchIds)) return;
    _watchedBranchIds = branchIds;
    if (branchIds.isEmpty) {
      _departments.clear();
      _services.clear();
    } else {
      _departments.watch(branchIds);
      _services.watch(branchIds);
    }
  }
}
