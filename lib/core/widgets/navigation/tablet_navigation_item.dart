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
    final style = _NavItemStyle.fromSelected(selected);
    final scheme = context.colorScheme;
    return Padding(
      padding: const AppPadding.verticalSm(),
      child: _NavigationItemSemantics(
        label: destination.label,
        selected: selected,
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: AppSizes.s56,
              height: AppSizes.s32,
              decoration: BoxDecoration(
                color: style.background(scheme),
                borderRadius: const AppRadius.full(),
              ),
              child: Icon(
                style.icon(destination),
                color: style.iconColor(scheme),
              ),
            ),
            AppText.badge(
              destination.label,
              tone: style.indicatorTone,
              fontWeight: style.weight,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
