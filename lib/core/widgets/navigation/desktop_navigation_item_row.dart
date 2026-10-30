part of 'app_navigation_shell.dart';

/// Shows one desktop destination's icon, label and count.
final class _DesktopNavigationItemRow extends StatelessWidget {
  const _DesktopNavigationItemRow({
    required this.destination,
    required this.style,
    required this.scheme,
  });

  final AppNavigationDestination destination;
  final _NavItemStyle style;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
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
