part of 'app_navigation_shell.dart';

/// Pill indicator displaying a tablet navigation item icon.
final class _TabletNavigationIconPill extends StatelessWidget {
  const _TabletNavigationIconPill({
    required this.style,
    required this.destination,
  });

  final _NavItemStyle style;
  final AppNavigationDestination destination;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return Container(
      width: AppSizes.s56,
      height: AppSizes.s32,
      decoration: BoxDecoration(
        color: style.background(scheme),
        borderRadius: const AppRadius.full(),
      ),
      child: Icon(style.icon(destination), color: style.iconColor(scheme)),
    );
  }
}
