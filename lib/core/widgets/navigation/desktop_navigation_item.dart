part of 'app_navigation_shell.dart';

/// One desktop sidebar destination.
final class _DesktopNavigationItem extends StatelessWidget {
  const _DesktopNavigationItem({
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
      padding: const AppPadding.navigationDestination(),
      child: _NavigationItemSemantics(
        label: destination.label,
        selected: selected,
        onTap: onTap,
        child: Material(
          color: style.background(scheme),
          borderRadius: const AppRadius.full(),
          child: SizedBox(height: AppSizes.s48, child: _row(style, scheme)),
        ),
      ),
    );
  }

  Widget _row(_NavItemStyle style, ColorScheme scheme) {
    return Row(
      children: [
        const EmptySize.s12Width(),
        Icon(style.icon(destination), color: style.iconColor(scheme)),
        const EmptySize.s12Width(),
        Expanded(
          child: AppText.label(
            destination.label,
            tone: style.sidebarTone,
            fontWeight: style.weight,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (destination.badgeCount case final count?) ...[
          _NavigationCountBadge(count: count),
          const EmptySize.s8Width(),
        ],
      ],
    );
  }
}
