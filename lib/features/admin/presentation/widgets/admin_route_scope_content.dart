part of 'admin_route_scope.dart';

/// Connects route selection to the list Cubits owned by the admin scope.
final class _AdminRouteScopeContent extends StatefulWidget {
  const _AdminRouteScopeContent({required this.child, this.routeClinicId});

  final Widget child;
  final String? routeClinicId;

  @override
  State<_AdminRouteScopeContent> createState() => _AdminRouteScopeState();
}

final class _AdminRouteScopeState extends State<_AdminRouteScopeContent>
    with _AdminRouteScopeStateMixin {
  @override
  Widget build(BuildContext context) {
    return InstitutionSelectionScope(selection: selection, child: widget.child);
  }
}
