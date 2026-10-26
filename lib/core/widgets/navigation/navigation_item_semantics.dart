part of 'app_navigation_shell.dart';

/// Announces a navigation destination consistently as a selected button.
final class _NavigationItemSemantics extends StatelessWidget {
  const _NavigationItemSemantics({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.child,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(onTap: onTap, child: child),
      ),
    );
  }
}
