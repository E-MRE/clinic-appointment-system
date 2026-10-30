part of 'medical_services_route_scope.dart';

/// Synchronizes [MedicalServiceListCubit] with the active branch in [InstitutionSelectionScope].
final class _MedicalServicesRouteScopeContent extends StatefulWidget {
  const _MedicalServicesRouteScopeContent({required this.child});

  final Widget child;

  @override
  State<_MedicalServicesRouteScopeContent> createState() =>
      _MedicalServicesRouteScopeContentState();
}

final class _MedicalServicesRouteScopeContentState
    extends State<_MedicalServicesRouteScopeContent> {
  late final MedicalServiceListCubit _cubit;
  late final InstitutionSelection _selection;
  String? _watchedBranch;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<MedicalServiceListCubit>();
    _selection = InstitutionSelectionScope.read(context);
    _selection.addListener(_syncBranchWatch);
    _syncBranchWatch();
  }

  @override
  void dispose() {
    _selection.removeListener(_syncBranchWatch);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _syncBranchWatch() {
    final branchId = _selection.branchId;
    if (branchId == _watchedBranch) return;
    _watchedBranch = branchId;
    if (branchId == null) {
      _cubit.clear();
    } else {
      _cubit.watch(branchId);
    }
  }
}
