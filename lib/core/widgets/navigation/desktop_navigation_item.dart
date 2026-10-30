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
          child: SizedBox(
            height: AppSizes.s48,
            child: _DesktopNavigationItemRow(
              destination: destination,
              style: style,
              scheme: scheme,
            ),
          ),
        ),
      ),
    );
  }
}
