part of 'app_navigation_shell.dart';

/// One tablet rail destination with a compact selected indicator.
final class _TabletNavigationItem extends StatelessWidget {
  const _TabletNavigationItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final AppNavigationDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = selected.navItemStyle;
    return Padding(
      padding: const AppPadding.verticalSm(),
      child: _NavigationItemSemantics(
        label: destination.label,
        selected: selected,
        onTap: onTap,
        child: Column(
          children: [
            _TabletNavigationIconPill(style: style, destination: destination),
            _TabletNavigationItemLabel(label: destination.label, style: style),
          ],
        ),
      ),
    );
  }
}
