part of 'app_navigation_shell.dart';

/// Shows the selected pill, icon and optional count on mobile.
final class _MobileNavigationIndicator extends StatelessWidget {
  const _MobileNavigationIndicator({
    required this.destination,
    required this.style,
  });

  final AppNavigationDestination destination;
  final _NavItemStyle style;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return SizedBox(
      width: AppSizes.navigationIndicatorWidth,
      height: AppSizes.s32,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (style.isSelected) const _MobileNavigationPill(),
          Icon(
            style.icon(destination),
            color: style.iconColor(scheme),
            size: AppSizes.s24,
          ),
          if (destination.badgeCount case final count?)
            Positioned(
              right: AppSizes.s8,
              child: _NavigationCountBadge(count: count),
            ),
        ],
      ),
    );
  }
}
