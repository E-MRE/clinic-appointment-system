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
    final style = _NavItemStyle.fromSelected(selected);
    return _NavigationItemSemantics(
      label: destination.label,
      selected: selected,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_indicator(context, style), _label(style)],
      ),
    );
  }

  Widget _indicator(BuildContext context, _NavItemStyle style) {
    final scheme = context.colorScheme;
    return SizedBox(
      width: AppSizes.navigationIndicatorWidth,
      height: AppSizes.s32,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (style.isSelected)
            DecoratedBox(
              decoration: BoxDecoration(
                color: scheme.secondaryContainer,
                borderRadius: const AppRadius.full(),
              ),
              child: const SizedBox.expand(),
            ),
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

  Widget _label(_NavItemStyle style) {
    return AppText.badge(
      destination.label,
      tone: style.indicatorTone,
      fontWeight: style.weight,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
