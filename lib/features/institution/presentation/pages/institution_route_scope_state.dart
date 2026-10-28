part of 'institution_route_scope.dart';

final class _InstitutionRouteScopeState
    extends State<_InstitutionRouteScopeContent> {
  late final InstitutionSelection selection;
  late final ClinicListCubit clinics;
  late final BranchListCubit branches;
  late final DepartmentListCubit departments;

  StreamSubscription<dynamic>? clinicSubscription;
  StreamSubscription<dynamic>? branchSubscription;

  @override
  void initState() {
    super.initState();
    selection = InstitutionSelection();
    clinics = context.read<ClinicListCubit>();
    branches = context.read<BranchListCubit>();
    departments = context.read<DepartmentListCubit>();
    clinicSubscription = clinics.stream.listen((state) {
      if (state is InstitutionListLoaded<Clinic> && state.items.isNotEmpty) {
        if (widget.routeClinicId case final routeClinicId?) {
          selection.selectClinic(routeClinicId);
          _onSelection();
          return;
        }
        final current = selection.clinicId;
        if (current == null || !state.items.any((item) => item.id == current)) {
          selection.selectClinic(state.items.first.id);
        }
        _onSelection();
      }
    });
    branchSubscription = branches.stream.listen((state) {
      if (state is InstitutionListLoaded<Branch> && state.items.isNotEmpty) {
        final current = selection.branchId;
        if (current == null || !state.items.any((item) => item.id == current)) {
          selection.selectBranch(state.items.first.id);
        }
      } else if (state is InstitutionListLoaded<Branch>) {
        selection.clearBranch();
      }
      _onSelection();
    });
    selection.addListener(_onSelection);
    if (widget.routeClinicId case final routeClinicId?) {
      selection.selectClinic(routeClinicId);
    }
  }

  @override
  void didUpdateWidget(_InstitutionRouteScopeContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    final routeClinicId = widget.routeClinicId;
    if (routeClinicId != null && routeClinicId != oldWidget.routeClinicId) {
      selection.selectClinic(routeClinicId);
    }
  }

  void _onSelection() {
    final clinicId = selection.clinicId;
    if (clinicId != _watchedClinic) {
      _watchedClinic = clinicId;
      _watchedBranch = null;
      departments.clear();
      branches.clear();
      if (clinicId != null) branches.watch(clinicId);
    }
    final branchId = selection.branchId;
    if (branchId != _watchedBranch) {
      _watchedBranch = branchId;
      departments.clear();
      if (branchId != null) {
        departments.watch(branchId);
      }
    }
  }

  String? _watchedClinic;
  String? _watchedBranch;

  @override
  void dispose() {
    selection.removeListener(_onSelection);
    clinicSubscription?.cancel();
    branchSubscription?.cancel();
    selection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InstitutionSelectionScope(
      selection: selection,
      child: _routeContent(),
    );
  }

  Widget _routeContent() {
    final routeClinicId = widget.routeClinicId;
    if (routeClinicId == null) return widget.child;
    return InstitutionListView<Clinic, ClinicListCubit>(
      emptyTitle: LocaleKeys.institution_notFound.tr(),
      emptyMessage: LocaleKeys.institution_notFoundDescription.tr(),
      onRetry: clinics.retry,
      loadedBuilder: (items) {
        if (items.any((clinic) => clinic.id == routeClinicId)) {
          return widget.child;
        }
        return AppScaffold(
          child: EmptyState(
            title: LocaleKeys.institution_notFound.tr(),
            message: LocaleKeys.institution_notFoundDescription.tr(),
            icon: const Icon(Icons.search_off),
            iconBackground: context.colorScheme.surfaceContainerHighest,
          ),
        );
      },
    );
  }
}
