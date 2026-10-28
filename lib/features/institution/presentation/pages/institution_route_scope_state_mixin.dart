part of 'institution_route_scope.dart';

/// Coordinates route selection with clinic, branch and department streams.
mixin _InstitutionRouteScopeStateMixin on State<_InstitutionRouteScopeContent> {
  late final InstitutionSelection selection;
  late final ClinicListCubit clinics;
  late final BranchListCubit branches;
  late final DepartmentListCubit departments;
  StreamSubscription<InstitutionListState<Clinic>>? clinicSubscription;
  StreamSubscription<InstitutionListState<Branch>>? branchSubscription;
  String? _watchedClinic;
  String? _watchedBranch;

  @override
  void initState() {
    super.initState();
    selection = InstitutionSelection();
    clinics = context.read<ClinicListCubit>();
    branches = context.read<BranchListCubit>();
    departments = context.read<DepartmentListCubit>();
    clinicSubscription = clinics.stream.listen(_onClinicsChanged);
    branchSubscription = branches.stream.listen(_onBranchesChanged);
    selection.addListener(_onSelectionChanged);
    if (widget.routeClinicId case final routeClinicId?) {
      selection.selectClinic(routeClinicId);
    }
  }

  @override
  void didUpdateWidget(_InstitutionRouteScopeContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    final routeClinicId = widget.routeClinicId;
    if (routeClinicId == null || routeClinicId == oldWidget.routeClinicId) {
      return;
    }
    selection.selectClinic(routeClinicId);
  }

  @override
  void dispose() {
    selection.removeListener(_onSelectionChanged);
    clinicSubscription?.cancel();
    branchSubscription?.cancel();
    selection.dispose();
    super.dispose();
  }

  void _onClinicsChanged(InstitutionListState<Clinic> state) {
    if (state is InstitutionListLoaded<Clinic>) {
      if (state.items.isEmpty) return;
    } else {
      return;
    }
    if (widget.routeClinicId case final routeClinicId?) {
      selection.selectClinic(routeClinicId);
      _onSelectionChanged();
      return;
    }
    final current = selection.clinicId;
    if (current == null ||
        state.items.any((item) => item.id == current) == false) {
      selection.selectClinic(state.items.first.id);
    }
    _onSelectionChanged();
  }

  void _onBranchesChanged(InstitutionListState<Branch> state) {
    if (state is InstitutionListLoaded<Branch>) {
      if (state.items.isEmpty) {
        selection.clearBranch();
      } else {
        final current = selection.branchId;
        if (current == null ||
            state.items.any((item) => item.id == current) == false) {
          selection.selectBranch(state.items.first.id);
        }
      }
    }
    _onSelectionChanged();
  }

  void _onSelectionChanged() {
    _watchSelectedClinic();
    _watchSelectedBranch();
  }

  void _watchSelectedClinic() {
    final clinicId = selection.clinicId;
    if (clinicId == _watchedClinic) return;
    _watchedClinic = clinicId;
    _watchedBranch = null;
    departments.clear();
    branches.clear();
    if (clinicId case final id?) branches.watch(id);
  }

  void _watchSelectedBranch() {
    final branchId = selection.branchId;
    if (branchId == _watchedBranch) return;
    _watchedBranch = branchId;
    departments.clear();
    if (branchId case final id?) departments.watch(id);
  }
}
