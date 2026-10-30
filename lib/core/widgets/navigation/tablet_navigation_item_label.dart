part of 'app_navigation_shell.dart';

/// Single-line badge text for a tablet navigation destination.
final class _TabletNavigationItemLabel extends StatelessWidget {
  const _TabletNavigationItemLabel({required this.label, required this.style});

  final String label;
  final _NavItemStyle style;

  @override
  Widget build(BuildContext context) {
    return AppText.badge(
      label,
      tone: style.indicatorTone,
      fontWeight: style.weight,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
