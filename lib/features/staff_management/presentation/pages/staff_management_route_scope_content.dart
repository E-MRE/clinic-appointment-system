part of 'staff_management_route_scope.dart';

/// Connects admin branch observation to the clinic-wide staff catalogues.
final class _StaffManagementRouteScopeContent extends StatefulWidget {
  const _StaffManagementRouteScopeContent({required this.child});

  final Widget child;

  @override
  State<_StaffManagementRouteScopeContent> createState() =>
      _StaffManagementRouteScopeContentState();
}

final class _StaffManagementRouteScopeContentState
    extends State<_StaffManagementRouteScopeContent>
    with _StaffManagementRouteScopeStateMixin {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
