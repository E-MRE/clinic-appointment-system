part of 'institution_route_scope.dart';

/// Connects route selection to the list Cubits owned by the route scope.
final class _InstitutionRouteScopeContent extends StatefulWidget {
  const _InstitutionRouteScopeContent({
    required this.child,
    this.routeClinicId,
  });

  final Widget child;
  final String? routeClinicId;

  @override
  State<_InstitutionRouteScopeContent> createState() =>
      _InstitutionRouteScopeState();
}

final class _InstitutionRouteScopeState
    extends State<_InstitutionRouteScopeContent>
    with _InstitutionRouteScopeStateMixin {
  @override
  Widget build(BuildContext context) {
    return InstitutionSelectionScope(
      selection: selection,
      child: _InstitutionRouteGuard(
        routeClinicId: widget.routeClinicId,
        child: widget.child,
      ),
    );
  }
}
