part of 'staff_management_route_scope.dart';

/// Replaces lookup observations when the selected clinic's branch ids change.
mixin _StaffManagementRouteScopeStateMixin
    on State<_StaffManagementRouteScopeContent> {
  late final BranchListCubit _branches;
  late final StaffDepartmentListCubit _departments;
  late final StaffServiceListCubit _services;
  late final InstitutionSelection _selection;
  List<String>? _watchedBranchIds;

  @override
  void initState() {
    super.initState();
    _branches = context.read<BranchListCubit>();
    _departments = context.read<StaffDepartmentListCubit>();
    _services = context.read<StaffServiceListCubit>();
    _selection = InstitutionSelectionScope.read(context);
    _selection.addListener(_handleSelectionChanged);
    _syncBranches();
    _refreshOverview(context);
  }

  @override
  void dispose() {
    _selection.removeListener(_handleSelectionChanged);
    super.dispose();
  }

  void _handleSelectionChanged() {
    _syncBranches();
    _refreshOverview(context);
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

  void _refreshOverview(BuildContext context) {
    final branchState = context.read<BranchListCubit>().state;
    final staffState = context.read<StaffListCubit>().state;
    final departmentState = context.read<StaffDepartmentListCubit>().state;
    final serviceState = context.read<StaffServiceListCubit>().state;
    context.read<StaffListOverviewCubit>().update(
      clinicId: _selection.clinicId,
      staff: staffState is InstitutionListLoaded<Staff>
          ? staffState.items
          : const [],
      branches: branchState is InstitutionListLoaded<Branch>
          ? branchState.items
          : const [],
      departments: departmentState is InstitutionListLoaded<Department>
          ? departmentState.items
          : const [],
      services: serviceState is InstitutionListLoaded<MedicalService>
          ? serviceState.items
          : const [],
    );
  }
}
