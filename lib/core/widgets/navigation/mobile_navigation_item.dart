part of 'app_navigation_shell.dart';

/// One mobile bottom navigation destination.
final class _MobileNavigationItem extends StatelessWidget {
  const _MobileNavigationItem({
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
    return _NavigationItemSemantics(
      label: destination.label,
      selected: selected,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _MobileNavigationIndicator(destination: destination, style: style),
          AppText.badge(
            destination.label,
            tone: style.indicatorTone,
            fontWeight: style.weight,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
